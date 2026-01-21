do_package_checks(codecov = FALSE)

get_stage("script") %>%
  add_step(step_rcmdcheck(
    args = c("--as-cran", "--no-manual"),
    error_on = "warning"
  ))

if (ci_on_circle()) {
  get_stage("before_deploy") %>%
    add_step(step_install_github("ropensci/rotemplate"))
  do_pkgdown(orphan = TRUE)
}
