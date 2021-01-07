vcr::use_cassette("set_env_var()", {
  test_that("set_env_var() works", {
    skip_on_cran()

    # 'repo' and 'user' need to be set explicitly because `github_info()` will
    # fail to lookup the git repo when running code coverage

    out <- set_env_var(
      repo = Sys.getenv("CIRCLE_REPO"),
      user = Sys.getenv("CIRCLE_OWNER"),
      list(foo = "test"),
      quiet = TRUE
    )
    expect_s3_class(out, "circle_api")
  })
})

vcr::use_cassette("get_env_vars()", {
  test_that("get_env_vars() works", {
    skip_on_cran()

    # 'repo' and 'user' need to be set explicitly because `github_info()` will
    # fail to lookup the git repo when running code coverage

    expect_silent(
      get_env_vars(
        repo = Sys.getenv("CIRCLE_REPO"),
        user = Sys.getenv("CIRCLE_OWNER")
      )
    )
  })
})

vcr::use_cassette("delete_env_var()", {
  test_that("delete_env_var() works", {
    skip_on_cran()

    # 'repo' and 'user' need to be set explicitly because `github_info()` will
    # fail to lookup the git repo when running code coverage

    expect_silent(
      delete_env_var(
        repo = Sys.getenv("CIRCLE_REPO"),
        user = Sys.getenv("CIRCLE_OWNER"),
        var = "foo", quiet = TRUE
      )
    )
  })
})
