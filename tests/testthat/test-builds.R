context("builds")

setwd("./travis-testthat")

test_that("get_pipelines() works", {
  pipelines <- get_pipelines(repo = repo, user = user)

  expect_is(pipelines, "circle_builds")
})
