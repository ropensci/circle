#' @title Circle CI API Client
#' @description This package provides functionality for interacting with the Circle CI API. Circle is a continuous integration service that allows for automated testing of software each time that software is publicly committed to a repository on GitHub. Setting up Circle is quite simple, requiring only a GitHub account, some public (or private) repository hosted on GitHub, and logging into to Circle to link it to that repository.
#'
#' Once you have your Circle account configured online, you can use this package to interact with and perform all operations on your Circle builds that you would normally perform via the website. This includes monitoring builds, modifying build environment settings and environment variables, and cancelling or restarting builds.
#'
#' Use of this package requires a Circle API key, which can be found [on the Circle CI website](https://circleci.com/account/api). API keys are disposable, but should still be treated securely. To use the key in R, store it as an environment variable using either `Sys.setenv("CIRCLE_CI_KEY" = "examplekey")` or by storing the key in your .Renviron file
#'
#' @examples
#' \dontrun{
#' # authenticate using a stored environment variables
#' Sys.setenv("CIRCLE_CI_KEY" = "examplekey")
#'
#' # check to see if you've authenticated correctly
#' get_user()
#' }
#'
#' @docType package
#' @name circleci
NULL

#' @title Get Circle CI user
#' @description Retrieve details about the authenticated Circle CI user.
#' @details This can be used to retrieve your own user profile details and/or as a \dQuote{Hello World!} to test authentication of Circle CI API key specified in `Sys.setenv("CIRCLE_CI_KEY" = "exampleapikey")`.
#' @param ... Additional arguments passed to an HTTP request function, such as [httr::GET()], via [circleHTTP()].
#' @return A list of class \dQuote{circle_user}.
#' @examples
#' \dontrun{get_user()}
#' @export
get_user <-
    function(...) {
        # GET: /me
        # Provides information about the signed in user.
        out <- circleHTTP("GET", path = "/me", ...)
        structure(out, class = "circle_user")
    }

#' @title List projects
#' @description Retrieve a list of Circle CI projects for the authenticated user.
#' @details Retrieves a very detailed list of projects and project-related information for all Circle CI projects attached to the current user.
#' @param ... Additional arguments passed to an HTTP request function, such as [httr::GET()], via [circleHTTP()].
#' @return A list of class \dQuote{circle_projects}, wherein each element is a \dQuote{circle_project}.
#' @seealso [get_build()], [get_pipelines()]
#' @examples
#' \dontrun{list_projects()}
#' @export
list_projects <-
    function(...) {
        # GET: /projects
        # List of all the projects you're following on CircleCI, with build information organized by branch.
        out <- circleHTTP("GET", path = "/projects", ...)
        browser()
        structure(lapply(out, structure, class = "circle_project"), class = "circle_projects")
    }


#' @title Get build artifacts
#' @description Retrieve artifacts from a specific build.
#' @details Retrieves details about artifacts from a specific build.
#' @param build A character string specifying the project name, or an object of class \dQuote{circle_build}. If the latter, there is no need to specify `project` or `user`.
#' @param project A character string specifying the project name, or an object of class \dQuote{circle_project}. If the latter, there is no need to specify `user`.
#' @param user A character string specifying the user name. This is not required if `build` is of class \dQuote{circle_build} and/or if `project` is of class \dQuote{circle_project} .
#' @param ... Additional arguments passed to an HTTP request function, such as [httr::GET()], via [circleHTTP()].
#' @return A list of class \dQuote{circle_artifacts}.
#' @examples
#' \dontrun{
#' list_artifacts(get_pipelines(limit = 1)[[1]])
#' }
#' @export
list_artifacts <-
    function(build = NULL, project, user, ...) {

        if (is.null(build)) {
            build = get_pipelines()[[1]]
        } else {
            build = build[[1]]
        }
        out <- circleHTTP("GET", path = paste0("/project/", build$vcs_type, "/",
                                               build$username, "/",
                                               build$reponame, "/",
                                               build$build_num, "/artifacts"), ...)
        if (length(out) == 0) {
            stop(sprintf("No build artifacts found for build number '%s'.", build$build_num))
        }
        structure(out, class = "circle_artifacts")
    }

#' @title Trigger build
#' @description Trigger a new build for a specific project branch
#' @details Trigger a new Circle CI build for a specific project branch.
#' @param project A character string specifying the project name, or an object of class \dQuote{circle_project}. If the latter, there is no need to specify `user`.
#' @param user A character string specifying the user name. This is not required if `project` is of class \dQuote{circle_project}.
#' @param branch A character string specifying the repository branch.
#' @param ... Additional arguments passed to an HTTP request function, such as [httr::GET()], via [circleHTTP()].
#' @return A list of class \dQuote{circle_build}.
#' @seealso [cancel_build()], [retry_build()]
#' @examples
#' \dontrun{
#' p <- list_projects()
#' new_build(p[[1]])
#' }
#' @export
new_build <-
    function(project, user, branch, ...) {
        # POST: /project/:username/:project/tree/:branch
        # Triggers a new build, returns a summary of the build. Optional build parameters can be set using an experimental API.
        if (inherits(project, "circle_project")) {
            user <- project$username
            project <- project$reponame
        }
        out <- circleHTTP("POST", path = paste0("/project/", user, "/", project, "/tree/", branch), ...)
        structure(out, class = "circle_build")
    }

#' @title Retrieve test metadata
#' @description Retrieve test metadata for a build.
#' @details Retrieve test metadata for a build.
#' @param build A character string specifying the project name, or an object of class \dQuote{circle_build}. If the latter, there is no need to specify `project` or `user`.
#' @param project A character string specifying the project name, or an object of class \dQuote{circle_project}. If the latter, there is no need to specify `user`.
#' @param user A character string specifying the user name. This is not required if `build` is of class \dQuote{circle_build} and/or if `project` is of class \dQuote{circle_project} .
#' @param ... Additional arguments passed to an HTTP request function, such as [httr::GET()], via [circleHTTP()].
#' @return A list of class \dQuote{circle_test_metadata}.
#' @examples
#' \dontrun{
#' test_metadata(get_pipelines(limit = 1)[[1]])
#' }
#' @export
test_metadata <-
    function(build, project, user, ...) {
        # GET: /project/:username/:project/:build_num/tests
        # Provides test metadata for a build
        if (inherits(build, "circle_build")) {
            user <- build$username
            project <- build$reponame
            build <- build$build_num
        } else if (inherits(project, "circle_project")) {
            user <- project$username
            project <- project$reponame
        }
        out <- circleHTTP("POST", path = paste0("/project/", user, "/", project, "/", build, "/tests"), ...)
        structure(out, class = "circle_test_metadata")
    }

#' @title Delete Project Cache
#' @description Delete project cache
#' @details Delete the project cache for a specified Circle CI project.
#' @param project A character string specifying the project name, or an object of class \dQuote{circle_project}. If the latter, there is no need to specify `user`.
#' @param user A character string specifying the user name. This is not required if `build` is of class \dQuote{circle_build} and/or if `project` is of class \dQuote{circle_project} .
#' @param ... Additional arguments passed to an HTTP request function, such as [httr::GET()], via [circleHTTP()].
#' @return A logical.
#' @examples
#' \dontrun{
#' delete_cache(list_projects()[[1]])
#' }
#' @export
delete_cache <-
    function(project, user, ...) {
        # DELETE: /project/:username/:project/build-cache
        # Clears the cache for a project
        if (inherits(project, "circle_project")) {
            user <- project$username
            project <- project$reponame
        }
        out <- circleHTTP("DELETE", path = paste0("/project/", user, "/", project, "/build_cache"), ...)
        return(out)
    }

