do_package_checks()

if (ci_on_circle()) {
  do_pkgdown()
}
