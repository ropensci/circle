vcr::use_cassette("create_checkout_key()", {
  test_that("create_checkout_key() works", {
    skip_on_cran()

    expect_s3_class(
      create_checkout_key(type = "user-key"),
      "circle_api"
    )
  })
})

vcr::use_cassette("delete_checkout_key()", {
  test_that("delete_checkout_key() works", {
    skip_on_cran()

    keys <- get_checkout_keys()
    expect_s3_class(keys, "circle_api")

    fp <- content(keys$response)$items[[1]]$fingerprint

    expect_s3_class(
      delete_checkout_key(fingerprint = fp),
      "circle_api"
    )
  })
})
