context("general")

vcr::use_cassette("get_circle_user()", {
  test_that("get_circle_user() works", {
    skip_on_cran()

    resp <- get_circle_user()

    expect_s3_class(resp, "circle_user")
    expect_equal(status_code(resp$response), 200)
  })
})

vcr::use_cassette("list_projects()", {
  test_that("list_projects() works", {
    skip_on_cran()

    resp <- list_projects()

    expect_equal(status_code(resp$response), 200)
    expect_gte(length(resp$content), 1)
    expect_s3_class(resp, "circle_api")
  })
})

vcr::use_cassette("new_build()", {
  test_that("triggering a new build works", {
    skip_on_cran()

    resp <- new_build()

    expect_equal(status_code(resp$response), 201)
    expect_match(resp[["content"]][["state"]], "pending")
    expect_s3_class(new_build(), "circle_api")
  })
})

vcr::use_cassette("has_checkout_key()", {
  test_that("checking the existence of checkout keys works", {
    skip_on_cran()

    resp <- has_checkout_key()

    expect_true(resp)
  })
})
