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
#' @seealso \code{\link{get_build}}, \code{\link{list_builds}}
#' @examples 
#' \dontrun{list_projects()}
#' @export
list_projects <- 
function(...) {
    # GET: /projects
    # List of all the projects you're following on CircleCI, with build information organized by branch.
    out <- circleHTTP("GET", path = "/projects", ...)
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
#' list_builds(limit = 5)
#' 
#' # list first 10 and next 10 builds
#' list_builds(limit = 10)
#' list_builds(limit = 10, offset = 10)
#' 
#' # list builds for a specific project
#' list_builds(list_projects[[1]])
#' }
#' @export
list_builds <-
function(project = NULL, user = NULL, limit = 30, offset = 0, ...) {
    
    if (!is.null(project)) {
        # GET: /project/:username/:project
        # Build summary for each of the last 30 builds for a single git repo.
        if (inherits(project, "circle_project")) {
            user <- project$username
            project <- project$reponame
        }
        out <- circleHTTP("GET", path = paste0("/project/", user, "/", project), ...)
        structure(lapply(out, structure, class = "circle_build"), class = "circle_builds")
    } else {
        # GET: /recent-builds
        # Build summary for each of the last 30 recent builds, ordered by build_num.
        out <- circleHTTP("GET", path = "/recent-builds", query = list(limit = limit, offset = offset), ...)
        structure(lapply(out, structure, class = "circle_build"), class = "circle_builds")
    }
    
}

#' @title Get build
#' @description Retrieve a specific build.
#' @details Retrieves details of a specific build.
#' @param build A character string specifying the project name, or an object of class \dQuote{circle_build}. If the latter, there is no need to specify \code{project} or \code{user}.
#' @param project A character string specifying the project name, or an object of class \dQuote{circle_project}. If the latter, there is no need to specify \code{user}.
#' @param user A character string specifying the user name. This is not required if \code{build} is of class \dQuote{circle_build} and/or if \code{project} is of class \dQuote{circle_project} .
#' @param ... Additional arguments passed to an HTTP request function, such as \code{\link[httr]{GET}}, via \code{\link{circleHTTP}}.
#' @return A list of class \dQuote{circle_build}.
#' @seealso \code{\link{list_builds}}
#' @examples
#' \dontrun{
#' # get build from a build object
#' get_build(list_builds(limit = 1)[[1]])
#' 
#' # get build by number, project, and user
#' get_build("buildnumber", "circleci", "cloudyr")
#' }
#' @export
get_build <- 
function(build, project, user, ...) {
    # GET: /project/:username/:project/:build_num
    # Full details for a single build. The response includes all of the fields from the build summary. This is also the payload for the notification webhooks, in which case this object is the value to a key named 'payload'.
    if (inherits(build, "circle_build")) {
        user <- build$username
        project <- build$reponame
        build <- build$build_num
    } else if (inherits(project, "circle_project")) {
        user <- project$username
        project <- project$reponame
    }        
    out <- circleHTTP("GET", path = paste0("/project/", user, "/", project, "/", build), ...)
    structure(out, class = "circle_build")
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
#' list_artifacts(list_builds(limit = 1)[[1]])
#' }
#' @export
list_artifacts <- 
function(build, project, user, ...) {
    # GET: /project/:username/:project/:build_num/artifacts
    # List the artifacts produced by a given build.
    if (inherits(build, "circle_build")) {
        user <- build$username
        project <- build$reponame
        build <- build$build_num
    } else if (inherits(project, "circle_project")) {
        user <- project$username
        project <- project$reponame
    }        
    out <- circleHTTP("GET", path = paste0("/project/", user, "/", project, "/", build), ...)
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
#' retry_build(list_builds(limit = 1)[[1]])
#' }
#' @export
retry_build <-
function(build, project, user, ...) {
    # POST: /project/:username/:project/:build_num/retry
    # Retries the build, returns a summary of the new build.
    if (inherits(build, "circle_build")) {
        user <- build$username
        project <- build$reponame
        build <- build$build_num
    } else if (inherits(project, "circle_project")) {
        user <- project$username
        project <- project$reponame
    }        
    out <- circleHTTP("POST", path = paste0("/project/", user, "/", project, "/", build, "/retry"), ...)
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
#' b <- retry_build(list_builds(limit = 1)[[1]])
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
#' test_metadata(list_builds(limit = 1)[[1]])
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
#' @param branch A character string specifying the repository branch.
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
    out <- circleHTTP("POST", path = paste0("/project/", user, "/", project, "/envvar"), body = v, encode = "json", ...)
    return(out)
}

#' @title Delete Environment Variable
#' @description Delete a Circle CI environment variable for a specific project.
#' @details Delete a Circle CI environment variable for a specific project.
#' @param project A character string specifying the project name, or an object of class \dQuote{circle_project}. If the latter, there is no need to specify \code{user}.
#' @param user A character string specifying the user name. This is not required if \code{project} is of class \dQuote{circle_project}.
#' @param branch A character string specifying the repository branch.
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
    out <- circleHTTP("DELETE", path = paste0("/project/", user, "/", project, "/envvar", var), body = v, encode = "json", ...)
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

#' @title Add Circle CI key to GitHub
#' @description Add a Circle CI API key to GitHub
#' @details Add a Circle CI API key to GitHub.
#' @param ... Additional arguments passed to an HTTP request function, such as \code{\link[httr]{GET}}, via \code{\link{circleHTTP}}.
#' @return Something...
#' @export
authenticate_github <- 
function(...) {
    # POST: /user/ssh-key
    # Adds a CircleCI key to your Github User account.
    out <- circleHTTP("POST", path = "/user/ssh-key", ...)
    out
}

#' @title Add Heroku key to Circle CI
#' @description Add Heroku key to Circle CI
#' @details Add Heroku key to Circle CI
#' @param ... Additional arguments passed to an HTTP request function, such as \code{\link[httr]{GET}}, via \code{\link{circleHTTP}}.
#' @return Something...
#' @export
add_heroku_key <- 
function(...) {
    # POST: /user/heroku-key
    # Adds your Heroku API key to CircleCI, takes apikey as form param name.
    out <- circleHTTP("POST", path = "/user/heroku-key", ...)
    out
}

