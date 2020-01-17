context("general")

withr::with_dir(
  "travis-testthat",
  {
    test_that("get_user() works", {
      expect_s3_class(get_user(), "circle_user")
    })

    test_that("list_projects() works", {
      expect_s3_class(
        list_projects(
          repo = repo,
          user = user
        ),
        "circle_api"
      )
    })

    test_that("triggering a new build works", {
      expect_s3_class(
        new_build(
          repo = repo,
          user = user
        ),
        "circle_api"
      )
    })

    test_that("checking the existence of checkout keys works", {
      expect_true(
        has_checkout_key()
      )
    })
  }
)
