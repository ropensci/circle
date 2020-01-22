withr::with_dir(
  "travis-testthat",
  {
    test_that("setting env vars works", {
      skip_on_cran()

      expect_silent(
        set_env_var(
          list(foo = "test"),
          quiet = TRUE
        )
      )
    })

    test_that("getting env vars works", {
      skip_on_cran()

      expect_silent(
        get_env_vars()
      )
    })

    test_that("deleting env vars works", {
      skip_on_cran()

      expect_silent(
        delete_env_var(
          var = "foo", quiet = TRUE
        )
      )
    })
  }
)
