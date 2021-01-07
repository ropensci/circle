vcr::use_cassette("enable_repo()", record = "new_episodes", {
  test_that("enable_repo() works", {
    skip_on_cran()

    # 'repo' and 'user' need to be set explicitly because `github_info()` will
    # fail to lookup the git repo when running code coverage
    foo <- suppressMessages(enable_repo(
      repo = Sys.getenv("CIRCLE_REPO"),
      user = Sys.getenv("CIRCLE_OWNER")
    ))

    expect_s3_class(foo, "circle_api")
  })
})
