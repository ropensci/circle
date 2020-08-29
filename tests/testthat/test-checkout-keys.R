withr::with_dir(
  "travis-testthat",
  {
    test_that("setting checkout keys works", {
      skip_on_cran()
      skip_on_travis()
      skip_on_appveyor()

      expect_s3_class(
        create_checkout_key(type = "user-key"),
        "circle_api"
      )
    })

    test_that("deleting checkout keys works", {
      skip_on_cran()
      skip_on_travis()
      skip_on_appveyor()

      keys <- get_checkout_keys()
      expect_s3_class(keys, "circle_api")

      fp <- content(keys$response)$items[[1]]$fingerprint

      expect_s3_class(
        delete_checkout_key(fingerprint = fp),
        "circle_api"
      )

      # also delete GH SHH key
      foo <- gh::gh("GET /user/keys",
        .token = Sys.getenv("CIRCLE_CHECKOUT_KEY")
      )
      # get id of last added key
      key_id <- vapply(foo, function(x) x$id,
        FUN.VALUE = integer(1)
      )[length(foo)]

      gh::gh("DELETE /user/keys/:key_id",
        key_id = key_id,
        .token = Sys.getenv("CIRCLE_CHECKOUT_KEY")
      )
    })
  }
)
