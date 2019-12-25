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

#' @description
#' `github_repo()` returns the true repository name as string.
#' @param info `[list]`\cr
#'   GitHub information for the repository, by default obtained through
#'   [github_info()].
#'
#' @export
#' @keywords internal
#' @rdname github_info
github_repo <- function(path = usethis::proj_get(),
                        info = github_info(path)) {
  paste(info$owner$login, info$name, sep = "/")
}

get_repo_data <- function(repo) {
  req <- gh::gh("/repos/:repo", repo = repo)
  return(req)
}

get_remote_url <- function(path) {
  r <- git2r::repository(path, discover = TRUE)
  remote_names <- git2r::remotes(r)
  if (!length(remote_names)) {
    stop("Failed to lookup git remotes")
  }
  remote_name <- "origin"
  if (!("origin" %in% remote_names)) {
    remote_name <- remote_names[1]
    warning(sprintf("No remote 'origin' found. Using: %s", remote_name))
  }
  git2r::remote_url(r, remote_name)
}

extract_repo <- function(url) {

  # account for http
  if (grepl("http://github.com", url)) {
    url <- sub("http://", "https://", url)
  }

  # account for ssh notation
  if (grepl("^git@github.com:", url)) {
    url <- sub("^git@github.com:", "https://github.com/", url)
  } else if (grepl("^git://github.com:", url)) {
    url <- sub("^git://github.com:", "https://github.com/", url)
  } else if (grepl("^git://github.com", url)) {
    url <- sub("^git://github.com", "https://github.com/", url)
  } else if (grepl("^ssh://git@github.com", url)) {
    url <- sub("^ssh://git@github.com/", "https://github.com/", url)
  }
  # account for "www"
  if (grepl("http://www.github.com", url)) {
    url <- sub("http://www.github.com", "https://github.com", url)
  } else if (grepl("https://www.github.com", url)) {
    url <- sub("https://www.github.com", "https://github.com", url)
  }

  # account for "user/pass"
  if (grepl("^http://(.+@)?github.com", url)) {
    url <- sub("^http://(.+@)?github.com", "https://github.com", url)
  } else if (grepl("^https://(.+@)github.com", url)) {
    url <- sub("^https://(.+@)github.com", "https://github.com", url)
  }

  if (!all(grepl("^https://github.com", url))) {
    stopc("Unrecognized repo format: ", url)
  }
  # remove .git
  url <- sub("\\.git$", "", url)
  # remove https: prefix
  sub("^https://github.com/", "", url)
}
