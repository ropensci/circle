test_that("github helper functions work", {
  unlink(paste0(tempdir(), "/circle"), recursive = TRUE)
  gert::git_clone(
    sprintf(
      "https://github.com/%s/%s.git",
      Sys.getenv("CIRCLE_OWNER"),
      Sys.getenv("CIRCLE_REPO")
    ),
    paste0(tempdir(), sprintf("/%s", Sys.getenv("CIRCLE_REPO")))
  )

  withr::with_dir(paste0(tempdir(), sprintf("/%s", Sys.getenv("CIRCLE_REPO"))), {
    # github_info() ------------------------------------------------------------
    if (Sys.getenv("CI") != "") {
      info <- github_info(.token = Sys.getenv("CIRCLE_R_PACKAGE_GITHUB_PAT"))
    } else {
      info <- github_info()
    }
    expect_s3_class(info, "gh_response")
    expect_equal(info$name, "circle")
    expect_equal(info$owner$login, "ropensci")
  })
})
