#' @title Interact with "Checkout Keys" on Circle CI
#' @description
#' Create, delete, query or check different types of checkout keys
#' for a specific Circle CI project.
#' Valid values for argument `type` are `"user-key"` or `"deploy-key"`.
#'
#' A "Checkout Key" on Circle CI is a specific SSH key which is used to checkout
#' repositories into a Circle CI build and possible deploy changes to the
#' repository.
#' Circle CI subdivides "Checkout Keys" into "user-key" and "deploy-key".
#'
#' Please see "Deployment" section in the "Getting Started" vignette for more
#' information.
#' @template repo
#' @template user
#' @template vcs
#' @template quiet
#' @param type `[character]`\cr
#'   Type of key to add. Options are "user-key" and "deploy-key".
#' @param fingerprint `[character]`\cr
#'   The fingerprint of the checkout key which should be deleted.
#' @template api_version
#' @name checkout_key
#' @return An object of class `circle_api` with the following elements
#' - `content` (queried content)
#' - `path` (API request)
#' - `response` (HTTP response information)
#' @export
#' @examples
#' \dontrun{
#' # by default a "user-key" will be created which can also be used for build
#' # deployments
#' create_checkout_key()
#'
#' # A "deploy-key" can only be used to checkout code from the repository into
#' # a Circle CI build
#' create_checkout_key(type = "deploy-key")
#' }
create_checkout_key <- function(repo = github_info()$name,
                                user = github_info()$owner$login,
                                type = "user-key",
                                api_version = "v2",
                                vcs_type = "gh",
                                quiet = FALSE) {

  if (type == "deploy-key") { # nocov start
    cli_alert_warning("Note that, despite the name, a 'deploy-key' does not
    grant permissions for build deployments to Github. Use a 'user-key'
    instead.")
  } # nocov end

  resp <- circle("POST",
    path = sprintf("/project/%s/%s/%s/checkout-key", vcs_type, user, repo),
    body = list(type = type), api_version = api_version
  )

  if (status_code(resp$response) == 500) { # nocov start
    cli_alert_warning("This error usually occurs if authorization with GitHub
      was not yet granted for Circle CI projects.
      In your Circle CI project page (web), go to {.field 'Project Settings'
      -> 'SSH Keys' -> 'User Key' -> 'Authorize with GitHub'}.
      This should only be required once.
      If you already added a user key once and see this error, remove all user
      keys and re-authenticate on the web page.
      See {.url https://discuss.circleci.com/t/rest-api-cant-create-a-project-user-checkout-key/934/4}
      for more information.", wrap = TRUE)
  } # nocov end

  stop_for_status(
    resp$response,
    sprintf("create checkout keys for repo %s/%s on Circle CI", user, repo)
  )

  if (!quiet) { # nocov start
    cli_alert_success("Successfully added a {.field {type}} to project
    {.field {user}/{repo}}.", wrap = TRUE)
  } # nocov end

  return(invisible(resp))
}

#' @rdname checkout_key
#' @export
#' @examples
#' \dontrun{
#' get_checkout_keys()
#' }
get_checkout_keys <- function(repo = github_info()$name,
                              user = github_info()$owner$login,
                              vcs_type = "gh",
                              api_version = "v2") {

  resp <- circle("GET",
    path = sprintf(
      "/project/%s/%s/%s/checkout-key",
      vcs_type, user, repo
    ),
    api_version = api_version
  )

  stop_for_status(
    resp$response,
    sprintf("get checkout keys for repo %s/%s on Circle CI", user, repo)
  )

  return(resp)
}

#' @rdname checkout_key
#' @export
#' @examples
#' \dontrun{
#' delete_checkout_key()
#' }
delete_checkout_key <- function(fingerprint = NULL,
                                repo = github_info()$name,
                                user = github_info()$owner$login,
                                type = "user-key",
                                api_version = "v2",
                                vcs_type = "gh") {

  if (is.null(fingerprint)) { # nocov start
    stop("Please provide the fingerprint of the key which should be deleted.")
  } # nocov end

  resp <- circle("DELETE",
    path = sprintf(
      "/project/%s/%s/%s/checkout-key/%s",
      vcs_type, user, repo, fingerprint
    ),
    api_version = api_version
  )

  stop_for_status(
    resp$response,
    sprintf("get checkout keys for repo %s/%s on Circle CI", user, repo)
  )

  # We cannot delete the corresponding key on Github because we do not have
  # the fingerprint or any other matching information. Issuing a warning..
  if (type == "deploy-key") { # nocov start
    cli_alert_warning("Make sure to also delete the corresponding SSH key on
      Github at {.url https://github.com/{user}/{repo}/settings/keys}!",
      wrap = TRUE
    )
  } else {
    cli_alert_warning("Make sure to also delete the corresponding SSH key on
      Github at {.url https://github.com/settings/keys}!",
      wrap = TRUE
    )
  } # nocov end

  return(resp)
}

#' @param preferred `[logical]`\cr
#'   Checks whether the requested type is the "preferred" key.
#' @rdname checkout_key
#' @export
#' @examples
#' \dontrun{
#' has_checkout_key()
#' }
has_checkout_key <- function(repo = github_info()$name,
                             user = github_info()$owner$login,
                             type = "github-user-key",
                             vcs_type = "gh",
                             preferred = TRUE) {

  info <- get_checkout_keys(repo = repo, user = user, vcs_type = vcs_type)
  key <- any(grepl(type, info))

  if (!key) { # nocov start
    cat_bullet(
      bullet = "cross", bullet_col = "red",
      sprintf("No '%s' found.", type)
    )
    return(FALSE)
  } # nocov end

  if (preferred) {
    preferred <- "true"
  } else {
    preferred <- "false"
  }

  key_name <- purrr::map_chr(info$content$items, ~ .x$type)
  is_pref <- purrr::map_lgl(info$content$items, ~ .x$preferred)

  df <- data.frame(key_name, is_pref)

  if (preferred) {
    ind <- which(df$is_pref == TRUE)
    return(df[ind, "key_name"] == type)
  } else {
    return(TRUE) # nocov
  }
}
