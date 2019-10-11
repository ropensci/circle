#' @title Circle CI API Client
#' @description This package provides functionality for interacting with the Circle CI API. Circle is a continuous integration service that allows for automated testing of software each time that software is publicly committed to a repository on GitHub. Setting up Circle is quite simple, requiring only a GitHub account, some public (or private) repository hosted on GitHub, and logging into to Circle to link it to that repository.
#'
#' Once you have your Circle account configured online, you can use this package to interact with and perform all operations on your Circle builds that you would normally perform via the website. This includes monitoring builds, modifying build environment settings and environment variables, and cancelling or restarting builds.
#'
#' Use of this package requires a Circle API key, which can be found \href{https://circleci.com/account/api}{on the Circle CI website}. API keys are disposable, but should still be treated securely. To use the key in R, store it as an environment variable using either \code{Sys.setenv("CIRCLE_CI_KEY" = "examplekey")} or by storing the key in your .Renviron file
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
#' @details This can be used to retrieve your own user profile details and/or as a \dQuote{Hello World!} to test authentication of Circle CI API key specified in \code{Sys.setenv("CIRCLE_CI_KEY" = "exampleapikey")}.
#' @param ... Additional arguments passed to an HTTP request function, such as \code{\link[httr]{GET}}, via \code{\link{circleHTTP}}.
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
#' @param ... Additional arguments passed to an HTTP request function, such as \code{\link[httr]{GET}}, via \code{\link{circleHTTP}}.
#' @return A list of class \dQuote{circle_projects}, wherein each element is a \dQuote{circle_project}.
#' @seealso \code{\link{get_build}}, \code{\link{get_pipelines}}
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

#' @title List builds
#' @description Retrieve a list of Circle CI project builds (among those available to the user) or for a specific project. Pagination paramaters allow one to retrieve all builds for a user or for a specific project.
#' @details Retrieves a very detailed list of projects and project-related information for all Circle CI projects attached to the current user.
#' @param project A character string specifying the project name, or an object of class \dQuote{circle_project}. If the latter, there is no need to specify \code{user}. If \code{NULL}, all builds for all user projects are returned.
#' @param user A character string specifying the user name. This is not required if \code{project} is of class \dQuote{circle_project}.
#' @param limit An integer specifying the number of builds to return, with a maximum of 100.
#' @param offset An integer used as a paging parameter.
#' @param ... Additional arguments passed to an HTTP request function, such as \code{\link[httr]{GET}}, via \code{\link{circleHTTP}}.
#' @return A list of class \dQuote{circle_builds}, wherein each element is a \dQuote{circle_build}.
#' @seealso \code{\link{get_build}}, \code{\link{list_projects}}
#' @examples
#' \dontrun{
#' # list most recent 5 builds across all projects
#' get_pipelines(limit = 5)
#'
#' # list first 10 and next 10 builds
#' get_pipelines(limit = 10)
#' get_pipelines(limit = 10, offset = 10)
#'
#' # list builds for a specific project
#' get_pipelines(list_projects[[1]])
#' }
#' @export
get_pipelines <-
    function(project = NULL, user = NULL, limit = 30, build_number = NULL, offset = 0,
             all = FALSE, vcs_type = "gh", ...) {

        if (all) {
            out <- circleHTTP("GET", path = "/recent-builds",
                              query = list(limit = limit, offset = offset), ...)
        } else if (is.null(project)) {
            # GET: /project/:username/:project
            # Build summary for each of the last 30 builds for a single git repo.
            user <- get_user()$login
            project <- basename(getwd())
            if (is.null(build_number)) {
                out <- circleHTTP("GET", path = sprintf("/project/%s/%s/%s/pipeline", vcs_type, user, project), ...)
            } else {
                out <- list(circleHTTP("GET", path = sprintf("/project/%s/%s/%s/%s/pipeline", vcs_type, user, project, build_number), ...))
            }
        } else if (!is.null(project) && is.null(user)) {
            user <- get_user()$login
            project <- project
            if (is.null(build_number)) {
                out <- circleHTTP("GET", path = sprintf("/project/%s/%s/%s/pipeline", vcs_type, user, project), ...)
            } else {
                out <- list(circleHTTP("GET", path = sprintf("/project/%s/%s/%s/%s/pipeline", vcs_type, user, project, build_number), ...))
            }
        } else if (!is.null(project) && !is.null(user)) {
            user <- user
            project <- project
            if (is.null(build_number)) {
                out <- circleHTTP("GET", path = sprintf("/project/%s/%s/%s/pipeline", vcs_type, user, project), ...)
            } else {
                out <- list(circleHTTP("GET", path = sprintf("/project/%s/%s/%s/%s/pipeline", vcs_type, user, project, build_number), ...))
            }
        }

        if (length(out) == 0) {
            stop(sprintf("No project named '%s' found for user '%s'.", project, user))
        }

        return(out)
    }

get_workflows = function(pipelines = NULL) {

    pipeline_id = sapply(pipelines$items, function(x) x$id)
    # retrieve from pipeline/id endpoint
    workflows = lapply(pipeline_id, function(id) circleHTTP("GET", path = sprintf("/pipeline/%s", id)))
    # retrieve from workflow/id endpoint
    workflows2 = lapply(workflows, function(workflows) circleHTTP("GET", path = sprintf("/workflow/%s", workflows$workflows[[1]]$id)))

    return(workflows2)
}

# cron builds are not shown
get_jobs = function(workflow = NULL, id_only = FALSE) {

    jobs = lapply(workflow, function(workflow) circleHTTP("GET", path = sprintf("/workflow/%s/jobs", workflow$id)))

    # simplify
    jobs = lapply(jobs, function(x) x$items)

    # set names
    names(jobs) = sapply(jobs, function(x) x[[1]]$job_number)

    # set names of jobs to have a more descriptive return
    for (i in 1:length(jobs)) {
        job_names = sapply(jobs[[i]], function(x) x$name)
        names(jobs[[i]]) = job_names
    }

    if (id_only) {
        jobs = lapply(jobs, function(x) jobs)
    }

    return(jobs)
}



#' @title Get build artifacts
#' @description Retrieve artifacts from a specific build.
#' @details Retrieves details about artifacts from a specific build.
#' @param build A character string specifying the project name, or an object of class \dQuote{circle_build}. If the latter, there is no need to specify \code{project} or \code{user}.
#' @param project A character string specifying the project name, or an object of class \dQuote{circle_project}. If the latter, there is no need to specify \code{user}.
#' @param user A character string specifying the user name. This is not required if \code{build} is of class \dQuote{circle_build} and/or if \code{project} is of class \dQuote{circle_project} .
#' @param ... Additional arguments passed to an HTTP request function, such as \code{\link[httr]{GET}}, via \code{\link{circleHTTP}}.
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

#' @title Retry build
#' @description Retry a Circle CI build.
#' @details Retry a Circle CI build.
#' @param build A character string specifying the project name, or an object of class \dQuote{circle_build}. If the latter, there is no need to specify \code{project} or \code{user}.
#' @param project A character string specifying the project name, or an object of class \dQuote{circle_project}. If the latter, there is no need to specify \code{user}.
#' @param user A character string specifying the user name. This is not required if \code{build} is of class \dQuote{circle_build} and/or if \code{project} is of class \dQuote{circle_project} .
#' @param ... Additional arguments passed to an HTTP request function, such as \code{\link[httr]{GET}}, via \code{\link{circleHTTP}}.
#' @return A list of class \dQuote{circle_build}.
#' @seealso \code{\link{cancel_build}}, \code{\link{new_build}}
#' @examples
#' \dontrun{
#' retry_build(get_pipelines(limit = 1)[[1]])
#' }
#' @export
retry_build <-
    function(build = NULL, ...) {

        if (is.null(build)) {
            build = get_pipelines()[[1]]
        } else {
            build = build[[1]]
        }
        project = build$reponame
        user = build$username
        vcs_type = build$vcs_type
        build_number = build$build_num
        browser()

        out = circleHTTP("POST", path = sprintf("/project/%s/%s/%s/%s/retry",
                                                vcs_type, user,
                                                project, build_number), ...)
        structure(out, class = "circle_build")
    }

#' @title Cancel build
#' @description Cancel a Circle CI build.
#' @details Cancel a Circle CI build.
#' @param build A character string specifying the project name, or an object of class \dQuote{circle_build}. If the latter, there is no need to specify \code{project} or \code{user}.
#' @param project A character string specifying the project name, or an object of class \dQuote{circle_project}. If the latter, there is no need to specify \code{user}.
#' @param user A character string specifying the user name. This is not required if \code{build} is of class \dQuote{circle_build} and/or if \code{project} is of class \dQuote{circle_project} .
#' @param ... Additional arguments passed to an HTTP request function, such as \code{\link[httr]{GET}}, via \code{\link{circleHTTP}}.
#' @return A list of class \dQuote{circle_build}.
#' @seealso \code{\link{new_build}}, \code{\link{retry_build}}
#' @examples
#' \dontrun{
#' b <- retry_build(get_pipelines(limit = 1)[[1]])
#' cancel_build(b)
#' }
#' @export
cancel_build <-
    function(build, project, user, ...) {
        # POST: /project/:username/:project/:build_num/cancel
        # Cancels the build, returns a summary of the build.
        if (inherits(build, "circle_build")) {
            user <- build$username
            project <- build$reponame
            build <- build$build_num
        } else if (inherits(project, "circle_project")) {
            user <- project$username
            project <- project$reponame
        }
        out <- circleHTTP("POST", path = paste0("/project/", user, "/", project, "/", build, "/cancel"), ...)
        structure(out, class = "circle_build")
    }

#' @title Trigger build
#' @description Trigger a new build for a specific project branch
#' @details Trigger a new Circle CI build for a specific project branch.
#' @param project A character string specifying the project name, or an object of class \dQuote{circle_project}. If the latter, there is no need to specify \code{user}.
#' @param user A character string specifying the user name. This is not required if \code{project} is of class \dQuote{circle_project}.
#' @param branch A character string specifying the repository branch.
#' @param ... Additional arguments passed to an HTTP request function, such as \code{\link[httr]{GET}}, via \code{\link{circleHTTP}}.
#' @return A list of class \dQuote{circle_build}.
#' @seealso \code{\link{cancel_build}}, \code{\link{retry_build}}
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
#' @param build A character string specifying the project name, or an object of class \dQuote{circle_build}. If the latter, there is no need to specify \code{project} or \code{user}.
#' @param project A character string specifying the project name, or an object of class \dQuote{circle_project}. If the latter, there is no need to specify \code{user}.
#' @param user A character string specifying the user name. This is not required if \code{build} is of class \dQuote{circle_build} and/or if \code{project} is of class \dQuote{circle_project} .
#' @param ... Additional arguments passed to an HTTP request function, such as \code{\link[httr]{GET}}, via \code{\link{circleHTTP}}.
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
#' @param project A character string specifying the project name, or an object of class \dQuote{circle_project}. If the latter, there is no need to specify \code{user}.
#' @param user A character string specifying the user name. This is not required if \code{build} is of class \dQuote{circle_build} and/or if \code{project} is of class \dQuote{circle_project} .
#' @param ... Additional arguments passed to an HTTP request function, such as \code{\link[httr]{GET}}, via \code{\link{circleHTTP}}.
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

#' @title Add Environment Variable(s)
#' @description Add Circle CI environment variable(s) for a specific project.
#' @details Add one or more Circle CI environment variable for a specific project.
#' @param project A character string specifying the project name, or an object of class \dQuote{circle_project}. If the latter, there is no need to specify \code{user}.
#' @param user A character string specifying the user name. This is not required if \code{project} is of class \dQuote{circle_project}.
#' @param var A named list containing key-value pairs of environment variable and value.
#' @param ... Additional arguments passed to an HTTP request function, such as \code{\link[httr]{GET}}, via \code{\link{circleHTTP}}.
#' @return Something...
#' @seealso \code{\link{delete_env}}
#' @examples
#' \dontrun{
#' # add environment variables
#' add_env(list_projects()[[1]], var = list(A = "123", B = "abc"))
#'
#' # remove environment variables, one at a time
#' delete_env(list_projects()[[1]], var = "A")
#' delete_env(list_projects()[[1]], var = "B")
#' }
#' @export
add_env <-
    function(project, user, var, ...) {
        # POST: /project/:username/:project/envvar
        # Creates a new environment variable
        if (inherits(project, "circle_project")) {
            user <- project$username
            project <- project$reponame
        }
        out <- circleHTTP("POST", path = paste0("/project/", user, "/", project, "/envvar"), body = var, encode = "json", ...)
        return(out)
    }

#' @title Delete Environment Variable
#' @description Delete a Circle CI environment variable for a specific project.
#' @details Delete a Circle CI environment variable for a specific project.
#' @param project A character string specifying the project name, or an object of class \dQuote{circle_project}. If the latter, there is no need to specify \code{user}.
#' @param user A character string specifying the user name. This is not required if \code{project} is of class \dQuote{circle_project}.
#' @param var A character string specifying the name of an environment variable
#' @param ... Additional arguments passed to an HTTP request function, such as \code{\link[httr]{GET}}, via \code{\link{circleHTTP}}.
#' @return A logical.
#' @seealso \code{\link{add_env}}
#' @examples
#' \dontrun{
#' # add environment variables
#' add_env(list_projects()[[1]], var = list(A = "123", B = "abc"))
#'
#' # remove environment variables, one at a time
#' delete_env(list_projects()[[1]], var = "A")
#' delete_env(list_projects()[[1]], var = "B")
#' }
#' @export
delete_env <-
    function(project, user, var, ...) {
        # POST: /project/:username/:project/envvar
        # Creates a new environment variable
        if (length(var) > 1) {
            stop("Only one environment variable can be specified at a time")
        }
        if (inherits(project, "circle_project")) {
            user <- project$username
            project <- project$reponame
        }
        out <- circleHTTP("DELETE", path = paste0("/project/", user, "/", project, "/envvar", var), body = var, encode = "json", ...)
        return(out)
    }

#' @title Generate SSH Key
#' @description Generate an SSH Key
#' @details Generate an SSH Key for a specific project
#' @param project A character string specifying the project name, or an object of class \dQuote{circle_project}. If the latter, there is no need to specify \code{user}.
#' @param user A character string specifying the user name. This is not required if \code{build} is of class \dQuote{circle_build} and/or if \code{project} is of class \dQuote{circle_project} .
#' @param ... Additional arguments passed to an HTTP request function, such as \code{\link[httr]{GET}}, via \code{\link{circleHTTP}}.
#' @return Something...
#' @export
generate_ssh_key <-
    function(project, user, ...) {
        # POST: /project/:username/:project/ssh-key
        # Create an ssh key used to access external systems that require SSH key-based authentication
        if (inherits(project, "circle_project")) {
            user <- project$username
            project <- project$reponame
        }
        out <- circleHTTP("POST", path = paste0("/project/", user, "/", project, "/ssh-key"), ...)
        out
    }
