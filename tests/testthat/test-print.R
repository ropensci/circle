context("print S3 methods")

test_that("s3 print method for 'circle_pipeline' works", {
  out <- get_pipelines(repo = repo, user = user)
  capture.output(expect_message(
    print(out),
    "A collection of 20 Circle CI pipelines"
  ))
})

test_that("s3 print method for 'circle_collection' works if class != 'circle_pipelines'", { # nolint
  out <- get_workflows(repo = repo, user = user)
  capture.output(expect_message(
    print(out),
    "A collection of 10 Circle CI workflows"
  ))
})

test_that("s3 print method for 'circle_workflow' works", {
  wf <- get_workflows(repo = repo, user = user)
  capture.output(expect_message(
    print(wf[[1]]),
    "A Circle CI workflow:"
  ))
})

test_that("s3 print method for 'circle_job' works", {
  job <- get_jobs(repo = repo, user = user)
  capture.output(expect_message(
    print(job[[1]]),
    "A Circle CI job:"
  ))
})
