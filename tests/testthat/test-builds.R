context("builds")

setwd("./travis-testthat")

# calls `get_workflows()` and `get_pipelines()` automatically
test_that("get_jobs() works", {
  out <- suppressMessages(get_jobs(repo = repo, user = user))

  expect_is(out, "list")
})
