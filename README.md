
<!-- badges: start -->

[![Build
Status](https://img.shields.io/travis/ropenscilabs/circle/master?label=macOS&logo=travis&style=flat-square)](https://travis-ci.org/ropenscilabs/circle)
[![CircleCI](https://img.shields.io/circleci/build/gh/ropenscilabs/circle/master?label=Linux&logo=circle&logoColor=green&style=flat-square)](https://circleci.com/gh/ropenscilabs/circle)
[![AppVeyor build
status](https://img.shields.io/appveyor/ci/ropensci/circle?label=Windows&logo=appveyor&style=flat-square)](https://ci.appveyor.com/project/ropensci/circle)
[![Codecov test
coverage](https://codecov.io/gh/ropenscilabs/circle/branch/master/graph/badge.svg)](https://codecov.io/gh/ropenscilabs/circle?branch=master)
[![Lifecycle:
maturing](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
<!-- badges: end -->

# circle

R client package for the Circle CI REST API

Most functionality is tailored towards the Circle CI [API
v2](https://github.com/CircleCI-Public/api-preview-docs) which follows
the

pipelines -\> workflows -\> jobs

principle.

Some functions use endpoints from the v1.1 API (e.g. `enable_repo()`)
because these endpoints do not yet work with the v2 API. Some are also
about to be removed soon [according to the Circle CI
team](https://github.com/CircleCI-Public/api-preview-docs/blob/master/docs/api-changes.md#endpoints-likely-being-removed-in-api-v2-still-available-in-v11-for-now).

## Get Started

See the [Getting
Started](https://ropenscilabs.github.io/circle/articles/circle.html)
vignette for an introduction.

# Acknowledgments

This package was inspired by the work of [Thomas J.
Leeper](https://github.com/leeper) on the (discontinued)
[cloudyr/circleci](https://github.com/cloudyr/circleci) package and by
the [ropenscilabs/travis](https://github.com/ropenscilabs/travis)
package.
