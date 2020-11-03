vcr::use_cassette("get_jobs()", {
  test_that("enable_repo() works", {
    skip_on_cran()

    # 'repo' and 'user' need to be set explicitly because `github_info()` will
    # fail to lookup the git repo when running code coverage

    # calls `get_workflows()` and `get_pipelines()` internally
    out <- suppressMessages(
      get_jobs(
        repo = Sys.getenv("CIRCLE_REPO"),
        user = Sys.getenv("CIRCLE_OWNER")
      )
    )

    expect_s3_class(out, "circle_collection")
  })
})

vcr::use_cassette("get_build_artifacts()", {
  test_that("get_build_artifacts() works", {
    skip_on_cran()

    # 'repo' and 'user' need to be set explicitly because `github_info()` will
    # fail to lookup the git repo when running code coverage
    expect_s3_class(
      get_build_artifacts(
        repo = Sys.getenv("CIRCLE_REPO"),
        user = Sys.getenv("CIRCLE_OWNER")
      ),
      "circle_api"
    )
  })
})

vcr::use_cassette("retry_workflow()", {
  test_that("retry_workflow() works", {
    skip_on_cran()

    # 'repo' and 'user' need to be set explicitly because `github_info()` will
    # fail to lookup the git repo when running code coverage
    workflow_id <- suppressMessages(
      get_workflows(
        repo = Sys.getenv("CIRCLE_REPO"),
        user = Sys.getenv("CIRCLE_OWNER")
      )[[10]]$id
    )
    expect_s3_class(
      retry_workflow(workflow_id),
      "circle_api"
    )
  })
})
