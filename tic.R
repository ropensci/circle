do_package_checks()

if (ci_on_circle()) {
  get_stage("before_deploy") %>%
    add_step(step_install_github("ropensci/rotemplate"))
  do_pkgdown(orphan = TRUE)
}
