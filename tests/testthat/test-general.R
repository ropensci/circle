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
    resp <- list_projects(repo = "circle", user = "ropenscilabs")

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
      repo = "circle", user = "ropenscilabs"
    )

    expect_equal(status_code(resp$response), 201)
    expect_match(resp[["content"]][["state"]], "pending")
    expect_s3_class(
      new_build(repo = "circle", user = "ropenscilabs"),
      "circle_api"
    )
  })
})

vcr::use_cassette("has_checkout_key()", {
  test_that("checking the existence of checkout keys works", {
    skip_on_cran()

    # 'repo' and 'user' need to be set explicitly because `github_info()` will
    # fail to lookup the git repo when running code coverage
    resp <- has_checkout_key(repo = "circle", user = "ropenscilabs")

    expect_true(resp)
  })
})
