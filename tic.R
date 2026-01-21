dsl_init()

get_stage("install") %>%
  add_step(step_install_deps(dependencies = TRUE)) %>%
  add_step(step_session_info())

get_stage("script") %>%
  add_step(step_rcmdcheck(
    args = c("--as-cran", "--no-manual"),
    build_args = "--force",
    error_on = "warning",
    check_dir = "check"
  ))

if (ci_on_circle()) {
  get_stage("before_deploy") %>%
    add_step(step_install_github("ropensci/rotemplate"))
  do_pkgdown(orphan = TRUE)
}
