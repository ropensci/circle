#' @title Generate/get or delete an SSH Key
#' @description Generate/get or delete an SSH Key
#' @details These functions provide the ability to deal with user SSH keys on
#'   Circle CI.
#' @param project A character string specifying the project name, or an object
#'   of class `circle_project`. If the latter, there is no need to
#'   specify `user`
#' @param user A character string specifying the user name. By default the user name
#' will be queried by `get_user()` and does not need to be set explicitly.
#' @param key A SSH key object as returned by `get_ssh_keys()`
#' @param ... Additional arguments passed to an HTTP request function, such as
#'   [httr::GET()], via [circleHTTP()].
#' @name ssh_key
#' @export
create_ssh_key <-
  function(project = NULL, user = NULL, type = "github-user-key",
             base = "https://circleci.com/api/v1.1", vcs_type = "gh", ...) {
    # does not yet support api v2
    if (is.null(user)) {
      user <- get_user()$content$login
    }
    if (is.null(project)) {
      project <- basename(getwd())
    }
    circleHTTP("POST",
      path = sprintf("/project/%s/%s/%s/checkout-key", vcs_type, user, project),
      body = list(type = type), base = base, ...
    )
  }

#' Get SSH key
#'
#' @rdname ssh_key
#' @export
get_ssh_keys <-
  function(project = NULL, user = NULL, vcs_type = "gh", ...) {
    if (is.null(user)) {
      user <- get_user()$content$login
    }
    if (is.null(project)) {
      project <- basename(getwd())
    }
    circleHTTP("GET",
      path = sprintf(
        "/project/%s/%s/%s/checkout-key",
        vcs_type, user, project
      ),
      ...
    )
  }

#' Delete SSH key
#'
#' @rdname ssh_key
#' @export
delete_ssh_key <-
  function(project = NULL, user = NULL, fingerprint, type = "github-user-key",
             base = "https://circleci.com/api/v1.1", vcs_type = "gh", ...) {

    # does not yet support api v2
    if (is.null(user)) {
      user <- get_user()$content$login
    }
    if (is.null(project)) {
      project <- basename(getwd())
    }
    circleHTTP("DELETE",
      path = sprintf(
        "/project/%s/%s/%s/checkout-key/%s",
        vcs_type, user, project, fingerprint
      ),
      base = base, ...
    )
  }
