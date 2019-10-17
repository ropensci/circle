github_add_key <- function(project = NULL, user = NULL,
                           pubkey, title = "circle") {
  if (is.null(user)) {
    user <- get_user()$content$login
  }
  if (is.null(project)) {
    project <- basename(getwd())
  }

  if (inherits(pubkey, "key")) {
    pubkey <- as.list(pubkey)$pubkey
  }
  if (!inherits(pubkey, "pubkey")) {
    stopc("`pubkey` must be an RSA/EC public key")
  }

  # check if we have enough rights to add a key
  check_admin_repo(user, project)

  key_data <- create_key_data(pubkey, title)

  # remove existing key
  remove_key_if_exists(key_data, user, project)
  # add public key to repo deploy keys on GitHub
  ret <- add_key(key_data, user, project)

  cli::cat_rule()
  cli::cat_bullet(
    bullet = "tick", bullet_col = "green",
    sprintf("Added a public deploy key to GitHub for '%s'.", project)
  )

  invisible(ret)
}

check_admin_repo <- function(owner, repo) {
  role_in_repo <- get_role_in_repo(owner, repo)
  if (role_in_repo != "admin") {
    stopc("Must have role admin to add deploy key to repo ", repo, ", not ", role_in_repo)
  }
}

add_key <- function(key_data, user, project) {

  # FIXME: catch status returns to process errors
  resp <- gh::gh("POST /repos/:owner/:repo/keys",
    owner = user, repo = project,
    title = key_data$title,
    key = key_data$key, read_only = key_data$read_only
  )

  cli::cat_bullet(
    bullet = "pointer", bullet_col = "yellow",
    sprintf("Adding deploy keys on GitHub and Circle CI for repo '%s'.", project)
  )

  invisible(resp)
}

get_role_in_repo <- function(owner, repo) {
  user <- github_user()$login

  req <- gh::gh("/repos/:owner/:repo/collaborators/:username/permission",
    owner = owner, repo = repo, username = user
  )
  req$permission
}

github_user <- function() {
  req <- gh::gh("GET /user")
  return(req)
}

remove_key_if_exists <- function(key_data, user, repo) {
  req <- gh::gh("/repos/:owner/:repo/keys", owner = user, repo = repo)

  if (length(req[[1]]) == 1) {
    return()
  }

  gh::gh(sprintf("DELETE %s", req[[1]]$url))
}

create_key_data <- function(pubkey, title) {
  list(
    "title" = title,
    "key" = openssl::write_ssh(pubkey),
    "read_only" = FALSE
  )
}
