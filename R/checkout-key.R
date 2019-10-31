#' @title Generate/get or delete an checkout Key
#' @description Generate/get or delete an checkout Key
#' @details These functions provide the ability to deal with user checkout keys on
#'   Circle CI.
#' @template repo
#' @template user
#' @template vcs
#' @param type Type of key to add. Options are "github-user-key" and
#'   "deploy-key".
#' @param fingerprint The fingerprint of the checkout key which should be deleted.
#' @template api_version
#' @name checkout_key
#' @export
create_checkout_key <- function(repo = github_info()$name,
                                user = get_user()$content$login,
                                type = "deploy-key",
                                api_version = "v1.1", vcs_type = "gh") {

  circleHTTP("POST",
    path = sprintf("/project/%s/%s/%s/checkout-key", vcs_type, user, repo),
    body = list(type = type), api_version = api_version
  )
}

#' Get checkout key
#'
#' @rdname checkout_key
#' @export
get_checkout_keys <- function(repo = github_info()$name,
                              user = get_user()$content$login,
                              vcs_type = "gh") {

  circleHTTP("GET",
    path = sprintf(
      "/project/%s/%s/%s/checkout-key",
      vcs_type, user, repo
    )
  )
}

#' Delete checkout key
#'
#' @rdname checkout_key
#' @export
delete_checkout_key <- function(repo = github_info()$name,
                                user = get_user()$content$login, fingerprint,
                                type = "github-user-key",
                                api_version = "v1.1",
                                vcs_type = "gh") {

  circleHTTP("DELETE",
    path = sprintf(
      "/project/%s/%s/%s/checkout-key/%s",
      vcs_type, user, repo, fingerprint
    ),
    api_version = api_version
  )
}
