test_that("github helper functions work", {
  unlink(paste0(tempdir(), "/circle"), recursive = TRUE)
  gert::git_clone(
    "https://github.com/ropenscilabs/circle.git",
    tempdir(check = TRUE)
  )

  withr::with_dir(paste0(tempdir(), "/circle"), {

    # github_info() ------------------------------------------------------------
    if (Sys.getenv("CI") != "") {
      info <- github_info(.token = Sys.getenv("PAT_GITHUB"))
    } else {
      info <- github_info()
    }
    expect_s3_class(info, "gh_response")
    expect_equal(info$name, "circle")
    expect_equal(info$owner$login, "ropenscilabs")
  })
})
