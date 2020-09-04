context("general")

withr::with_dir(
  "travis-testthat",
  {
    test_that("get_circle_user() works", {
      skip_on_cran()

      expect_s3_class(get_circle_user(), "circle_user")
    })

    test_that("list_projects() works", {
      skip_on_cran()

      expect_s3_class(
        list_projects(),
        "circle_api"
      )
    })

    test_that("triggering a new build works", {
      skip_on_cran()

      expect_s3_class(
        new_build(),
        "circle_api"
      )
    })

    test_that("checking the existence of checkout keys works", {
      skip_on_cran()

      expect_true(
        has_checkout_key()
      )
    })
  }
)
