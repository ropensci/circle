context("checkout-key")

setwd("./travis-testthat")

test_that("getting checkout keys works", {
  expect_is(
    get_checkout_keys(repo = repo, user = user),
    "circle_api"
  )
})
