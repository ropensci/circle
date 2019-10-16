#' @title Generate/get or delete an checkout Key
#' @description Generate/get or delete an checkout Key
#' @details These functions provide the ability to deal with user checkout keys on
#'   Circle CI.
#' @template project
#' @template user
#' @template vcs
#' @param type Type of key to add. Options are "github-user-key" and
#'   "deploy-key".
#' @param fingerprint The fingerprint of the checkout key which should be deleted.
#' @template api_version
#' @name checkout_key
#' @export
create_checkout_key <- function(project = NULL, user = NULL, type = "deploy-key",
             api_version = "v1.1", vcs_type = "gh") {
    if (is.null(user)) {
      user <- get_user()$content$login
    }
    if (is.null(project)) {
      project <- basename(getwd())
    }
    circleHTTP("POST",
      path = sprintf("/project/%s/%s/%s/checkout-key", vcs_type, user, project),
      body = list(type = type), api_version = api_version
    )
  }

#' Get checkout key
#'
#' @rdname checkout_key
#' @export
get_checkout_keys <- function(project = NULL, user = NULL, vcs_type = "gh") {
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
      )
    )
  }

#' Delete checkout key
#'
#' @rdname checkout_key
#' @export
delete_checkout_key <- function(project = NULL, user = NULL, fingerprint,
                           type = "github-user-key",
                           api_version = "v1.1",
                           vcs_type = "gh") {

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
             api_version = api_version)
  }
