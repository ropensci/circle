vcr::use_cassette("enable_repo()", {
  test_that("enable_repo() works", {
    skip_on_cran()

    # enable
    foo <- suppressMessages(enable_repo())

    expect_true(foo)
  })
})
