#' @export
print.circle_projects <-
function(x, ...) {
    browser()
    m <- sprintf(ngettext(length(x), "List of %d project", "List of %d projects",
                          domain = NULL), length(x))
    cat(m)
    cat(sapply(x, function(x) x$reponame))
    invisible(x)
}

#' @export
print.circle_builds <-
function(x, ...) {
    sprintf(ngettext(length(x), "List of %d build", "List of %d builds",
                          domain = NULL), length(x))

    builds = lapply(x, function(x) x[c("failed", "build_url", "branch", "author_date")])
    builds = setNames(builds, sapply(x, function(x) x$reponame))

    message("Showing the last 2 builds:")
    print(builds[1:2])
    invisible(x)
}

