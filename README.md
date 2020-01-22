
<!-- badges: start -->

[![Build
Status](https://img.shields.io/travis/ropenscilabs/circle/master?label=macOS&logo=travis&style=flat-square)](https://travis-ci.org/ropenscilabs/circle)
[![CircleCI](https://img.shields.io/circleci/build/gh/ropenscilabs/circle/master?label=Linux&logo=circle&logoColor=green&style=flat-square)](https://circleci.com/gh/ropenscilabs/circle)
[![AppVeyor build
status](https://img.shields.io/appveyor/ci/ropensci/circle?label=Windows&logo=appveyor&style=flat-square)](https://ci.appveyor.com/project/ropensci/circle)
[![codecov](https://codecov.io/gh/ropenscilabs/circle/branch/master/graph/badge.svg)](https://codecov.io/gh/ropenscilabs/circle)
[![Lifecycle:
maturing](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
[![rOpenSci
footer](http://ropensci.org/public_images/github_footer.png)](https://ropensci.org)
<!-- badges: end -->

# circle

R client package for the Circle CI REST API

This package aims to execute tasks such as build restarts, log queries
or setting environment variables for the CI service provider [Circlei
CI](https://circleci.com/) from within R. It also simplifies the setup
process for build deployments via `use_circle_deploy()`.

{circle} does not come with an option to setup Circle CI YAML files.
Please see the related [{tic}](https://github.com/ropensci/tic) package
for such functionality.

## API versions

All functionality uses the Circle CI [API
v2](https://github.com/CircleCI-Public/api-preview-docs) which follows
the **pipelines** -\> **workflows** -\> **jobs** approach. This API
version is still in beta and might undergo some changes in the near
future.

Some functions can also be used via API versions v1.1 and v1 via the
`api_version` argument. However, this will only work if the respective
endpoints are available for both API versions. There should be no need
in practice to this.

If you want to get more information, have a look at the [document
explaining changes between v1.1 and
v2](https://github.com/CircleCI-Public/api-preview-docs/blob/master/docs/api-changes.md#endpoints-likely-being-removed-in-api-v2-still-available-in-v11-for-now).

## Installation

Development Version:

``` r
remotes::install_github("ropenscilabs/circle")
```

## Get Started

See the [Getting
Started](https://ropenscilabs.github.io/circle/articles/circle.html)
vignette for an introduction.

## Note to developers

This packages relies on using API keys to test its functionality. Please
have a look at section [“Testing the
package”](https://github.com/ropenscilabs/circle/blob/master/.github/CONTRIBUTING.md#testing-the-package)
for more information.

# Acknowledgments

This package was inspired by the work of [Thomas J.
Leeper](https://github.com/leeper) on the (discontinued)
[cloudyr/circleci](https://github.com/cloudyr/circleci) package and by
the [ropenscilabs/travis](https://github.com/ropenscilabs/travis)
package.
