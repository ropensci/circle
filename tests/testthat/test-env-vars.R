vcr::use_cassette("set_env_var()", {
  test_that("set_env_var() works", {
    skip_on_cran()

    out <- set_env_var(
      list(foo = "test"),
      quiet = TRUE
    )
    expect_true(out)
  })
})

vcr::use_cassette("get_env_vars()", {
  test_that("get_env_vars() works", {
    skip_on_cran()

    expect_silent(
      get_env_vars()
    )
  })
})

vcr::use_cassette("delete_env_var()", {
  test_that("delete_env_var() works", {
    skip_on_cran()

    expect_silent(
      delete_env_var(
        var = "foo", quiet = TRUE
      )
    )
  })
})
