context("general")

setwd("./travis-testthat")

test_that("get_user() works", {
  expect_s3_class(get_user(), "circle_user")
})

test_that("list_projects() works", {
  expect_s3_class(list_projects(), "circle_api")
})

test_that("triggering a new build works", {
  expect_s3_class(new_build(), "circle_api")
})
