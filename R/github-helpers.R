#' Github information
#'
#' @description
#' Retrieves metadata about a Git repository from GitHub.
#'
#' `github_info()` returns a list as obtained from the GET "/repos/:repo" API.
#'
#' @param path `[string]`\cr
#'   The path to a GitHub-enabled Git repository (or a subdirectory thereof).
#' @family GitHub functions
github_info <- function(path = rprojroot::find_package_root_file()) {
  remote_url <- get_remote_url(path)
  repo <- extract_repo(remote_url)
  get_repo_data(repo)
}

get_repo_data <- function(repo) {
  req <- gh::gh("/repos/:repo", repo = repo)
  return(req)
}

get_remote_url <- function(path) {
  r <- git2r::repository(path, discover = TRUE)
  remote_names <- git2r::remotes(r)
  if (!length(remote_names)) {
    stopc("Failed to lookup git remotes")
  }
  remote_name <- "origin"
  if (!("origin" %in% remote_names)) {
    remote_name <- remote_names[1]
    warningc("No remote 'origin' found. Using: ", remote_name)
  }
  git2r::remote_url(r, remote_name)
}

extract_repo <- function(url) {
  if (grepl("^git@github.com:", url)) {
    url <- sub("^git@github.com:", "https://github.com/", url)
  } else if (grepl("^git://github.com", url)) {
    url <- sub("^git://github.com", "https://github.com", url)
  } else if (grepl("^http://(.+@)?github.com", url)) {
    url <- sub("^http://(.+@)?github.com", "https://github.com", url)
  } else if (grepl("^https://(.+@)github.com", url)) {
    url <- sub("^https://(.+@)github.com", "https://github.com", url)
  }
  if (!all(grepl("^https://github.com", url))) {
    stopc("Unrecognized repo format: ", url)
  }
  url <- sub("\\.git$", "", url)
  sub("^https://github.com/", "", url)
}
