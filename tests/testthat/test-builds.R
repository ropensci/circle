# withr::with_dir(
#   "travis-testthat",
#   {
#     # calls `get_workflows()` and `get_pipelines()` automatically
#     test_that("get_jobs() works", {
#       skip_on_cran()
#
#       out <- suppressMessages(get_jobs())
#
#       expect_is(out, "circle_collection")
#     })
#
#     test_that("getting job artifacts works", {
#       skip_on_cran()
#
#       expect_s3_class(
#         get_build_artifacts(),
#         "circle_api"
#       )
#     })
#
#     test_that("restarting a workflow works", {
#       skip_on_cran()
#
#       workflow_id <- suppressMessages(get_workflows())[[10]]$id
#       expect_s3_class(
#         retry_workflow(workflow_id),
#         "circle_api"
#       )
#     })
#   }
# )
