context("print S3 methods")

test_that("s3 print method for 'circle_pipeline' works", {
  skip_on_cran()

  out <- get_pipelines()
  capture.output(expect_message(
    print(out),
    "A collection of 20 Circle CI pipelines"
  ))
})

test_that("s3 print method for 'circle_collection' works if class != 'circle_pipelines'", { # nolint

  skip_on_cran()

  out <- get_workflows()
  capture.output(expect_message(
    print(out),
    "A collection of 10 Circle CI workflows"
  ))
})

test_that("s3 print method for 'circle_workflow' works", {
  skip_on_cran()

  wf <- get_workflows()
  capture.output(expect_message(
    print(wf[[1]]),
    "A Circle CI workflow:"
  ))
})

test_that("s3 print method for 'circle_job' works", {
  skip_on_cran()

  job <- get_jobs()
  capture.output(expect_message(
    print(job[[1]]),
    "A Circle CI job:"
  ))
})
