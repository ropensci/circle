context("authentication")

setwd("./travis-testthat")

test_that("Circle enable works", {

  # enable
  foo <- suppressMessages(enable_repo(repo = repo, user = user))

  expect_true(foo)
})
