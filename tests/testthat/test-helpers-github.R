test_that("github helper functions work", {
  unlink(paste0(tempdir(), "/circle"), recursive = TRUE)
  usethis::create_from_github("ropenscilabs/circle",
    destdir = tempdir(check = TRUE), open = FALSE
  )

  withr::with_dir(paste0(tempdir(), "/circle"), {

    # github_info() ------------------------------------------------------------
    info <- github_info()
    expect_s3_class(info, "gh_response")
    expect_equal(info$name, "circle")
    expect_equal(info$owner$login, "ropenscilabs")
  })
})
