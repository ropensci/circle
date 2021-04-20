#' @title Github information
#'
#' @description
#' Retrieves metadata about a Git repository from GitHub.
#'
#' `github_info()` returns a list as obtained from the GET "/repos/:repo" API.
#'
#' @param path `[string]`\cr
#'   The path to a GitHub-enabled Git repository (or a subdirectory thereof).
#' @template token
#' @template remote
#' @return Object of class `gh_response` (list type) with information about the
#'   queried repository.
#' @keywords internal
github_info <- function(path = ".",
                        remote = "origin",
                        .token = NULL) {
  remote_url <- get_remote_url(path, remote)
  repo <- extract_repo(remote_url)
  get_repo_data(repo, .token)
}

get_repo_data <- function(repo, .token = NULL) {
  req <- gh::gh("/repos/:repo", repo = repo, .token = .token)
  return(req)
}

get_remote_url <- function(path, remote) {
  remote_names <- gert::git_remote_list(path)
  if (!length(remote_names)) { # nocov start
    stop("Failed to lookup git remotes")
  } # nocov end
  remote_name <- remote
  if (!(remote_name %in% remote_names)) { # nocov start
    stop(sprintf(
      "No remote named '%s' found in remotes: '%s'.",
      remote_name, remote_names
    ))
  } # nocov end
  return(remote_names[remote_names$name == remote]$url)
}

extract_repo <- function(url) {
  # Borrowed from gh:::github_remote_parse
  re <- "github[^/:]*[/:]([^/]+)/(.*?)(?:\\.git)?$"
  m <- regexec(re, url)
  match <- regmatches(url, m)[[1]]

  if (length(match) == 0) { # nocov start
    stop("Unrecognized repo format: ", url)
  } # nocov end

  paste0(match[2], "/", match[3])
}
