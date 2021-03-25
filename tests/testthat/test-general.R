vcr::use_cassette("get_circle_user()", {
  test_that("get_circle_user() works", {
    skip_on_cran()

    # 'repo' and 'user' need to be set explicitly because `github_info()` will
    # fail to lookup the git repo when running code coverage

    resp <- get_circle_user()

    expect_s3_class(resp, "circle_user")
    expect_equal(status_code(resp$response), 200)
  })
})

vcr::use_cassette("list_projects()", {
  test_that("list_projects() works", {
    skip_on_cran()

    # 'repo' and 'user' need to be set explicitly because `github_info()` will
    # fail to lookup the git repo when running code coverage
    resp <- list_projects(
      repo = Sys.getenv("CIRCLE_REPO"),
      user = Sys.getenv("CIRCLE_OWNER")
    )

    expect_equal(status_code(resp$response), 200)
    expect_gte(length(resp$content), 1)
    expect_s3_class(resp, "circle_api")
  })
})

vcr::use_cassette("new_build()", {
  test_that("triggering a new build works", {
    skip_on_cran()

    # 'repo' and 'user' need to be set explicitly because `github_info()` will
    # fail to lookup the git repo when running code coverage
    resp <- new_build(
      repo = "circle", user = "ropensci"
    )

    expect_equal(status_code(resp$response), 201)
    expect_match(resp[["content"]][["state"]], "pending")
    expect_s3_class(
      new_build(
        repo = Sys.getenv("CIRCLE_REPO"),
        user = Sys.getenv("CIRCLE_OWNER")
      ),
      "circle_api"
    )
  })
})

vcr::use_cassette("has_checkout_key()", {
  test_that("checking the existence of checkout keys works", {
    skip_on_cran()

    # 'repo' and 'user' need to be set explicitly because `github_info()` will
    # fail to lookup the git repo when running code coverage
    resp <- has_checkout_key(
      repo = Sys.getenv("CIRCLE_REPO"),
      user = Sys.getenv("CIRCLE_OWNER")
    )

    expect_true(resp)
  })
})
