vcr::use_cassette("create_checkout_key()", {
  test_that("create_checkout_key() works", {
    skip_on_cran()

    # 'repo' and 'user' need to be set explicitly because `github_info()` will
    # fail to lookup the git repo when running code coverage

    expect_s3_class(
      create_checkout_key(
        type = "user-key",
        repo = Sys.getenv("CIRCLE_REPO"),
        user = Sys.getenv("CIRCLE_OWNER")
      ),
      "circle_api"
    )
  })
})

vcr::use_cassette("delete_checkout_key()", {
  test_that("delete_checkout_key() works", {
    skip_on_cran()

    # 'repo' and 'user' need to be set explicitly because `github_info()` will
    # fail to lookup the git repo when running code coverage

    keys <- get_checkout_keys(
      repo = Sys.getenv("CIRCLE_REPO"),
      user = Sys.getenv("CIRCLE_OWNER")
    )
    expect_s3_class(keys, "circle_api")

    fp <- content(keys$response)$items[[1]]$fingerprint

    expect_s3_class(
      delete_checkout_key(
        fingerprint = fp,
        repo = "circle", user = "ropensci"
      ),
      "circle_api"
    )
  })
})
