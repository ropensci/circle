test_that("github helper functions work", {
  unlink(paste0(tempdir(), "/circle"), recursive = TRUE)
  usethis::create_from_github("ropenscilabs/circle",
    destdir = tempdir(check = TRUE), open = FALSE
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
