get_stage("install") %>%
  add_step(step_install_github("ropensci/rotemplate"))

do_package_checks()

if (ci_on_circle()) {
  do_pkgdown(orphan = TRUE)
}
