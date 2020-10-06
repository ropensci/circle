vcr::use_cassette("get_jobs()", {
  test_that("enable_repo() works", {
    skip_on_cran()

    # calls `get_workflows()` and `get_pipelines()` internally
    out <- suppressMessages(get_jobs())

    expect_is(out, "circle_collection")
  })
})

vcr::use_cassette("get_build_artifacts()", {
  test_that("get_build_artifacts() works", {
    skip_on_cran()

    expect_s3_class(
      get_build_artifacts(),
      "circle_api"
    )
  })
})

vcr::use_cassette("retry_workflow()", {
  test_that("retry_workflow() works", {
    skip_on_cran()

    workflow_id <- suppressMessages(get_workflows())[[10]]$id
    expect_s3_class(
      retry_workflow(workflow_id),
      "circle_api"
    )
  })
})
