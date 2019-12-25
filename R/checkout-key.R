#' @title Generate/get or delete an checkout Key
#' @description Functions to interact with "checkout keys" on Circle CI.
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
                                user = github_info()$owner$login,
                                type = "deploy-key",
                                api_version = "v1.1",
                                vcs_type = "gh") {

  circle("POST",
    path = sprintf("/project/%s/%s/%s/checkout-key", vcs_type, user, repo),
    body = list(type = type), api_version = api_version
  )
}

#' Get checkout key
#'
#' @rdname checkout_key
#' @export
get_checkout_keys <- function(repo = github_info()$name,
                              user = github_info()$owner$login,
                              vcs_type = "gh") {

  circle("GET",
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
                                user = github_info()$owner$login, fingerprint,
                                type = "github-user-key",
                                api_version = "v1.1",
                                vcs_type = "gh") {

  circle("DELETE",
    path = sprintf(
      "/project/%s/%s/%s/checkout-key/%s",
      vcs_type, user, repo, fingerprint
    ),
    api_version = api_version
  )
}

#' Check if a specific key type exists in the Circle CI project
#'
#' @param preferred Checks whether the requested type is the "preferred" key.
#' @rdname checkout_key
#' @export
has_checkout_key <- function(repo = github_info()$name,
                             user = github_info()$owner$login,
                             type = "github-user-key",
                             vcs_type = "gh",
                             preferred = "true") {

  info <- get_checkout_keys(repo = repo, user = user, vcs_type = vcs_type)
  key <- any(grepl(type, info))

  if (!key) {
    cli::cat_bullet(
      bullet = "cross", bullet_col = "red",
      sprintf("No '%s' found.", type)
    )
    return(FALSE)
  }

  key_name <- purrr::map_chr(info$content$items, ~ .x$type)
  is_pref <- purrr::map_lgl(info$content$items, ~ .x$preferred)
  df <- data.frame(key_name, is_pref)

  if (preferred) {
    ind <- which(df$is_pref == TRUE)
    return(df[ind, "key_name"] == type)
  } else {
    return(TRUE)
  }
}
