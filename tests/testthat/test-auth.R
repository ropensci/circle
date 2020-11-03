vcr::use_cassette("enable_repo()", record = "new_episodes", {
  test_that("enable_repo() works", {
    skip_on_cran()

    # 'repo' and 'user' need to be set explicitly because `github_info()` will
    # fail to lookup the git repo when running code coverage
    foo <- suppressMessages(enable_repo(repo = "circle", user = "ropenscilabs"))

    expect_true(foo)
  })
})
