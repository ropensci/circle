vcr::use_cassette("s3-print-circle_pipeline", {
  test_that("s3 print method for 'circle_pipeline' works", {
    skip_on_cran()

    # 'repo' and 'user' need to be set explicitly because `github_info()` will
    # fail to lookup the git repo when running code coverage

    out <- get_pipelines(repo = "circle", user = "ropenscilabs")
    capture.output(expect_message(
      print(out),
      "A collection of 20 Circle CI pipelines"
    ))
  })
})

vcr::use_cassette("s3-print-circle_collection", {
  test_that("s3 print method for 'circle_collection' works", {
    skip_on_cran()

    # 'repo' and 'user' need to be set explicitly because `github_info()` will
    # fail to lookup the git repo when running code coverage

    out <- get_workflows(repo = "circle", user = "ropenscilabs")
    capture.output(expect_message(
      print(out),
      "A collection of 11 Circle CI workflows"
    ))
  })
})

vcr::use_cassette("s3-print-circle_workflow", {
  test_that("s3 print method for 'circle_workflow' works", {
    skip_on_cran()

    # 'repo' and 'user' need to be set explicitly because `github_info()` will
    # fail to lookup the git repo when running code coverage

    wf <- get_workflows(repo = "circle", user = "ropenscilabs")
    capture.output(expect_message(
      print(wf[[1]]),
      "A Circle CI workflow:"
    ))
  })
})

vcr::use_cassette("s3-print-circle_job", {
  test_that("s3 print method for 'circle_job' works", {
    skip_on_cran()

    # 'repo' and 'user' need to be set explicitly because `github_info()` will
    # fail to lookup the git repo when running code coverage

    job <- get_jobs(repo = "circle", user = "ropenscilabs")
    capture.output(expect_message(
      print(job[[1]]),
      "A Circle CI job:"
    ))
  })
})
