context("builds")

setwd("./travis-testthat")

# calls `get_workflows()` and `get_pipelines()` automatically
test_that("get_jobs() works", {
  out <- suppressMessages(get_jobs(repo = repo, user = user))

  expect_is(out, "list")
})

test_that("getting job artifacts works", {
  expect_s3_class(
    get_build_artifacts(repo = repo, user = user),
    "circle_api"
  )
})

test_that("restarting a workflow works", {
  workflow_id <- suppressMessages(get_workflows())[[10]]$id
  expect_s3_class(
    retry_workflow(workflow_id),
    "circle_api"
  )
})
