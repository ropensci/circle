vcr::use_cassette("set_env_var()", {
  test_that("set_env_var() works", {
    skip_on_cran()

    # 'repo' and 'user' need to be set explicitly because `github_info()` will
    # fail to lookup the git repo when running code coverage

    out <- set_env_var(
      repo = "circle", user = "ropenscilabs",
      list(foo = "test"),
      quiet = TRUE
    )
    expect_true(out)
  })
})

vcr::use_cassette("get_env_vars()", {
  test_that("get_env_vars() works", {
    skip_on_cran()

    # 'repo' and 'user' need to be set explicitly because `github_info()` will
    # fail to lookup the git repo when running code coverage

    expect_silent(
      get_env_vars(repo = "circle", user = "ropenscilabs")
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
        repo = "circle", user = "ropenscilabs",
        var = "foo", quiet = TRUE
      )
    )
  })
})
