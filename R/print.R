#' @export
print.circle_projects <- 
function(x, ...) {
    m <- sprintf(ngettext(length(x), "List of %d project", "List of %d projects", domain = NULL), length(x))
    cat(m)
    invisible(x)
}

#' @export
print.circle_builds <- 
function(x, ...) {
    m <- sprintf(ngettext(length(x), "List of %d build", "List of %d builds", domain = NULL), length(x))
    cat(m)
    invisible(x)
}

