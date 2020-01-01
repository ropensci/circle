context("print S3 methods")

test_that("s3 print method for 'circle_pipeline' works", {
  out <- get_pipelines(repo = repo, user = user)
  capture.output(expect_message(
    print(out),
    "A collection of 20 Circle CI pipelines"
  ))
})

test_that("s3 print method for 'circle_workflow' works", {
  out <- get_workflows(repo = repo, user = user)
  capture.output(expect_message(
    print(out),
    "A collection of 10 Circle CI workflows"
  ))
})

test_that("s3 print method for 'circle_job' works", {
  out <- get_jobs(repo = repo, user = user)
  capture.output(expect_message(
    print(out),
    "A collection of 10 Circle CI jobs"
  ))
})
