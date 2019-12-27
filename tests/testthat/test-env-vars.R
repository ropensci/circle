context("env-vars")

setwd("./travis-testthat")

test_that("setting env vars works", {
  expect_silent(
    set_env_var(
      list(foo = "test"),
      quiet = TRUE,
      repo = repo, user = user
    )
  )
})

test_that("getting env vars works", {
  expect_silent(
    get_env_vars(
      repo = repo, user = user
    )
  )
})

test_that("deleting env vars works", {
  expect_silent(
    delete_env_var(
      var = "foo", quiet = TRUE,
      repo = repo, user = user
    )
  )
})
