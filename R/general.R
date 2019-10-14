#' @title Get Circle CI user
#' @description Retrieve details about the authenticated Circle CI user.
#' @details This can be used to retrieve your own user profile details and/or as
#'   a `Hello World!` to test authentication of Circle CI API key
#'   specified in `Sys.setenv("CIRCLE_CI_KEY" = "exampleapikey")`.
#' @return A list of class `circle_user`.
#' @examples
#' \dontrun{get_user()}
#' @export
get_user <- function() {
    # GET: /me
    # Provides information about the signed in user.
    out <- circleHTTP("GET", path = "/me")
    return(structure(out, class = "circle_user"))
}

#' @title List projects
#' @description Retrieve a list of Circle CI projects for the authenticated
#'   user.
#' @importFrom stats setNames
#' @details Retrieves a very detailed list of projects and project-related
#'   information for all Circle CI projects attached to the current user.
#' @return A list of `circle_project`s.
#' @seealso [get_builds()], [get_pipelines()]
#' @examples
#' \dontrun{
#' projects = list_projects()
#' }
#' @export
list_projects <- function() {

    # GET: /projects
    # List of all the projects you're following on CircleCI, with build information organized by branch.
    out <- circleHTTP("GET", path = "/projects", api_version = "v1.1")
    out = out$content
    requireNamespace("stats", quietly = TRUE)
    out = setNames(out, sapply(out, function(x) x$reponame))
    return(out)
}

#' @title Get build artifacts
#' @description Retrieve artifacts from a specific build.
#' @details Retrieves details about artifacts from a specific build.
#' @param build A single Circle CI job object as returned by `get_jobs()`.
#' @return A list of build artifacts
#' @examples
#' \dontrun{
#' list_artifacts(get_builds()[["1"]]$build)
#' }
#' @export
list_artifacts <- function(build = NULL) {

    if (is.null(build)) {
        build = get_pipelines()[[1]]
    }

    out <- circleHTTP("GET", path = sprintf("/project/%s/%s/artifacts",
                                            build$project_slug,
                                            build$job_number))

    if (length(out$content$items) == 0) {
        stop(sprintf("No build artifacts found for build number '%s'.",
                     build$job_number), call. = FALSE)
    }
    return(out$content$items)
}

#' @importFrom httr status_code
retry_build <- function(build = NULL) {

    if (is.null(build)) {
        build = get_pipelines()[[1]]
    }

    out <- circleHTTP("POST", path = sprintf("/project/%s/%s/retry",
                                            build$project_slug,
                                            build$job_number),
                      api_version = "v1.1")
    if (status_code(out$response) == 200) {
        message(sprintf("Successfully restarted build '#%s'.",
                        build$job_number))
    }

    return(invisible(out))
}

#' @title Trigger build
#' @description Trigger a new build for a specific project branch
#' @details Trigger a new Circle CI build for a specific project branch.
#' @template project
#' @template user
#' @template vcs
#' @param branch A character string specifying the repository branch.
#' @seealso [retry_build()]
#' @examples
#' \dontrun{
#' new_build()
#' }
#' @export
new_build <- function(project = NULL, user = NULL, vcs_type = "gh", branch = "master") {

    if (is.null(project)) {
        project <- basename(getwd())
    }
    if (is.null(user)) {
        user <- get_user()$content$login
    }

    out <- circleHTTP("POST", path = sprintf("/project/%s/%s/%s/pipeline",
                                             vcs_type,
                                             user,
                                             project),
                      body = list(branch = branch)
    )

    if (status_code(out$response) == 202) {
        message(sprintf("Successfully triggered a build for project '%s' on branch '%s'.",
                        project, branch))
    }

    return(invisible(out))
}

#' @title Enable a repo on Circle CI
#' @description Follows a repo on Circle CI so that builds can be triggered
#' @template project
#' @template user
#' @template vcs
#' @template api_version
#' @examples
#' \dontrun{
#' enable_project()
#' }
#' @export
enable_project <- function(project = NULL, user = NULL, vcs_type = "gh",
                           api_version = "v1.1") {

    if (is.null(project)) {
        project <- basename(getwd())
    }
    if (is.null(user)) {
        user <- get_user()$content$login
    }

    out <- circleHTTP("POST", path = sprintf("/project/%s/%s/%s/follow",
                                             vcs_type,
                                             user,
                                             project),
                      api_version = api_version
    )

    if (status_code(out$response) == 200) {
        message(sprintf("Successfully enabled project '%s' on Circle CI.",
                        project))
    }

    return(invisible(out))
}

#' @title Delete Project Cache
#' @description Delete project cache
#' @details Delete the project cache for a specified Circle CI project.
#' @template project
#' @template user
#' @template vcs
#' @return A logical.
#' @examples
#' \dontrun{
#' delete_cache(list_projects()[[1]])
#' }
#' @export
delete_cache <- function(project = NULL, user = NULL, vcs_type = "gh") {
    if (is.null(project)) {
        project <- basename(getwd())
    }
    if (is.null(user)) {
        user <- get_user()$content$login
    }
    out <- circleHTTP("DELETE", path = sprintf("/project/%s/%s/%s/build-cache",
                                               vcs_type,
                                               user,
                                               project),
                      api_version = "v1.1"
    )
    out = jsonlite::fromJSON(content(out$response, "text"), simplifyVector = FALSE)
    return(out$status)
}
