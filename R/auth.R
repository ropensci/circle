auth_circle <- function() {

  yml = tryCatch({
    readLines("~/.circleci/cli.yml")
  },
  warning=function(cond) {
    cli::cat_bullet(
      bullet = "pointer", bullet_col = "yellow",
      c("To interact with the Circle CI API, an API is required.",
        "This is a one-time procedure. The token will be stored in your home directory in the '.circleci' directory.")
    )
    message("Querying API token...")
    utils::browseURL("https://circleci.com/account/api")
    wait_for_clipboard_token()
    return(readLines("~/.circleci/cli.yml"))
  })

  # create api token if none is found but config file exists
  if (!any(grepl("token", yml))) {
    requireNamespace("utils", quietly = TRUE)
    utils::browseURL("https://circleci.com/account/api")
    wait_for_clipboard_token()
  }
}

wait_for_clipboard_token <- function() {

  cli::cat_bullet(
    bullet = "info", bullet_col = "yellow",
    " Waiting for API token to appear on the clipboard."
  )
  Sys.sleep(3)

  repeat {
    token = readline("Please paste the API token to the console.\n")
    if (is_token(token)) break
    Sys.sleep(0.1)
  }
  cli::cat_bullet(
    bullet = "pointer", bullet_col = "yellow",
    " Detected token, clearing clipboard."
  )
  requireNamespace("clipr", quietly = TRUE)
  tryCatch(
    clipr::write_clip(""),
    error = function(e) {
      warning("Error clearing clipboard: ", conditionMessage(e))
    }
  )
  dir.create("~/.circleci")
  writeLines(sprintf(c("host: https://circleci.com", "endpoint: graphql-unstable",
                       "token: %s"), token), "~/.circleci/cli.yml")
}

is_token <- function(token) {
  grepl("^[0-9a-f]{40}$", token)
}

circle <- function(endpoint = "") {
  paste0("https://circleci.com/api/v1.1", endpoint)
}

read_token = function() {
  yml = readLines("~/.circleci/cli.yml")
  token = yml[which(grepl("token", yml))]
  token = strsplit(token, " ")[[1]][2]
  return(token)

}
