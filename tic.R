do_package_checks(
  codecov = FALSE,
  args = c("--as-cran"),
  build_args = "--force",
  error_on = "warning"
)

if (ci_on_circle()) {
  get_stage("before_deploy") %>%
    add_step(step_install_github("ropensci/rotemplate"))
  do_pkgdown(orphan = TRUE)
}
