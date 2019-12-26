new_circle_builds <- function(x) {
  stopifnot(x[["@type"]] == "builds")
  new_circle_collection(
    lapply(x[["items"]], new_circle_build),
    circle_attr(x),
    "builds"
  )
}

new_circle_build <- function(x) {
  stopifnot(x[["@type"]] == "build")
  new_circle_object(x, "build")
}

new_circle <- function(x, attr, subclass) {
  attr[["names"]] <- names(x)
  attributes(x) <- attr
  structure(x, class = c(paste0("circle_", subclass), "circle"))
}

new_circle_object <- function(x, subclass) {
  new_circle(circle_no_attr(x), circle_attr(x), subclass)
}

new_circle_collection <- function(x, attr, subclass) {
  new_circle(x, attr, c(subclass, "collection"))
}

circle_attr <- function(x) {
  is_attr <- grepl("^@", names(x))
  x[is_attr]
}

circle_no_attr <- function(x) {
  is_attr <- grepl("^@", names(x))
  x[!is_attr]
}

#' @export
format.circle_collection <- function(x, ...) {
  if (length(x) == 0) {
    return(invisible(x))
  } else {
    cli_text("A collection of {length(x)} Circle CI builds:\n
             {bullets(vapply(shorten(x), format, short = TRUE, character(1)))}")
  }
}

bullets <- function(x) {
  if (length(x) == 0) {
    return(character())
  }
  paste0("- ", x, collapse = "\n")
}

shorten <- function(x) {
  n_max <- 6
  if (length(x) > n_max) {
    c(x[seq_len(n_max - 1)], "...")
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

#' @export
format.circle <- function(x, ..., short = FALSE) {
  kv <- key_value(shorten(x))
  if (short) {
    paste0(kv, collapse = ", ")
  } else {
    bullets(kv)
  }
}

#' @export
print.circle <- function(x, ...) {
  cat(format(x))
  invisible(x)
}
