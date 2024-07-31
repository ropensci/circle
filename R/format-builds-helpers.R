new_circle_pipelines <- function(x) {
  new_circle_collection(
    lapply(x[["items"]], new_circle_pipeline),
    circle_attr(x)
  )
}

new_circle_workflows <- function(x) {
  new_circle_collection(
    lapply(x[["items"]], new_circle_workflow),
    circle_attr(x)
  )
}

new_circle_jobs <- function(x) {
  new_circle_collection(
    lapply(x[["items"]], new_circle_job),
    circle_attr(x)
  )
}

# ------------------------------------------------------------------------------

new_circle_pipeline <- function(x, attr, subclass) {
  new_circle_object(x, "pipeline")
}

new_circle_workflow <- function(x, attr, subclass) {
  new_circle_object(x, "workflow")
}

new_circle_job <- function(x, attr, subclass) {
  new_circle_object(x, "job")
}

# ------------------------------------------------------------------------------

new_circle <- function(x, attr, subclass) {
  attr[["names"]] <- names(x)
  attributes(x) <- attr
  structure(x, class = c(paste0("circle_", subclass), "circle"))
}

new_circle_object <- function(x, subclass) {
  new_circle(circle_no_attr(x), circle_attr(x), subclass)
}

new_circle_collection <- function(x, attr) {
  new_circle(x, attr, "collection")
}

circle_attr <- function(x) {
  is_attr <- grepl("^@", names(x))
  x[is_attr]
}

circle_no_attr <- function(x) {
  is_attr <- grepl("^@", names(x))
  x[!is_attr]
}

#' @exportS3Method circle::format
format.circle_collection <- function(x, ...) {
  if (length(x) == 0) {
    return(invisible(x)) # nocov
  } else {
    if (!class(x[[1]])[1] == "circle_pipeline") {
      text <- vapply(seq_along(x), function(y) {
        paste0("- id: ", x[[y]]$id,
          "\n  status: ", x[[y]]$status,
          "\n  stopped at: ", x[[y]]$stopped_at, "\n",
          collapse = ""
        )
      }, character(1))
    } else {
      text <- vapply(seq_along(x), function(y) {
        paste0("- id: ", x[[y]]$id, "\n",
          collapse = ""
        )
      }, character(1))
    }

    cli::cli_text("")
    cli_text("A collection of {length(x)} Circle CI
    {strsplit(class(x[[1]]), '_')[[1]][2]}s:\n\n")
    # cli_par()

    return(text)
  }
}

#' @exportS3Method circle::format
format.circle_workflow <- function(x, ...) {

  kv <- key_value(shorten(x, n_max = 10))

  cli_text("A Circle CI workflow:\n\n{bullets(kv)}")

}

#' @exportS3Method circle::format
format.circle_job <- function(x, ...) {

  kv <- key_value(shorten(x, n_max = 10))

  cli_text("A Circle CI job:\n\n{bullets(kv)}")

}

# ------------------------------------------------------------------------------

bullets <- function(x) {
  if (length(x) == 0) {
    return(character()) # nocov
  }
  paste0("- ", x, "\n\n", collapse = "")
}

shorten <- function(x, n_max = 6) {

  if (length(x) > n_max) {
    c(x[seq_len(n_max - 1)], "...") # nocov
  } else {
    x
  }
}

key_value <- function(x) {
  paste0(
    ifelse(names(x) == "", "", paste0(names(x), ": ")),
    x
  )
}

# ------------------------------------------------------------------------------

#' @export
print.circle_job <- function(x, ...) {
  cat(format(x))
  invisible(x)
}

#' @export
print.circle_workflow <- function(x, ...) {
  cat(format(x))
  invisible(x)
}

#' @export
print.circle_collection <- function(x, ...) {
  cat(format(x), sep = "")

  cli::cli_text("")
  cli::cli_alert_info("To view the details for a single item, print the
    returned list item(s), e.g. {.code get_jobs()[[2]]} would show the
    information for the second last job.", wrap = TRUE)
  invisible(x)
}
