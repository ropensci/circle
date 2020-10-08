# context("print S3 methods")

vcr::use_cassette("s3-print-circle_pipeline", {
  test_that("s3 print method for 'circle_pipeline' works", {
    skip_on_cran()

    out <- get_pipelines()
    capture.output(expect_message(
      print(out),
      "A collection of 20 Circle CI pipelines"
    ))
  })
})

vcr::use_cassette("s3-print-circle_collection", {
  test_that("s3 print method for 'circle_collection' works", {
    skip_on_cran()

    out <- get_workflows()
    capture.output(expect_message(
      print(out),
      "A collection of 11 Circle CI workflows"
    ))
  })
})

vcr::use_cassette("s3-print-circle_workflow", {
  test_that("s3 print method for 'circle_workflow' works", {
    skip_on_cran()

    wf <- get_workflows()
    capture.output(expect_message(
      print(wf[[1]]),
      "A Circle CI workflow:"
    ))
  })
})

vcr::use_cassette("s3-print-circle_job", {
  test_that("s3 print method for 'circle_job' works", {
    skip_on_cran()

    job <- get_jobs()
    capture.output(expect_message(
      print(job[[1]]),
      "A Circle CI job:"
    ))
  })
})
