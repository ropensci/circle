# withr::with_dir(
#   "travis-testthat",
#   {
#     test_that("Circle enable works", {
#       skip_on_cran()
#
#       # enable
#       foo <- suppressMessages(enable_repo())
#
#       expect_true(foo)
#     })
#   }
# )
