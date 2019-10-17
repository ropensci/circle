
<!-- badges: start -->

[![Travis-CI Build
Status](https://travis-ci.org/pat-s/circle.svg?branch=master)](https://travis-ci.org/pat-s/circle)
[![Build
status](https://ci.appveyor.com/api/projects/status/r8w1psd0f5r4hs6t/branch/master?svg=true)](https://ci.appveyor.com/project/pat-s/circle/branch/master)
[![Codecov test
coverage](https://codecov.io/gh/pat-s/circle/branch/master/graph/badge.svg)](https://codecov.io/gh/pat-s/circle?branch=master)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/pat-s/circle?branch=master&svg=true)](https://ci.appveyor.com/project/pat-s/circle)
<!-- badges: end -->

# circle

R client package for the Circle CI REST API

# Deployment keys

The easiest way to get deployment from Circle CI builds to Github repos
running is by using `use_circle_deploy()`.

There two different types of keys on Circle CI:

  - checkout keys

  - SSH keys

## Checkout keys

The former are used to checkout your repository so that the build is
starting. If you’ve connected Circle CI to Github already, you will have
a “deploy key” stored in every repository to be able to checkout the
code.

There is no advantage in adding a “github-user-key” to the checkout
section. This key would not give you any more rights regarding
deployment.

## SSH keys

These are actually used to grant deployment access from the build to
your repository. The private key will be added to your repo setting on
Circle CI while the public key will be stored as a “deploy key” in your
repository on Github.

If you do not want to use `use_circle_deploy()` and go the manual way of
adding a SSH key to Circle CI, please be aware of [this
issue](https://discuss.circleci.com/t/adding-ssh-keys-fails/7747).

# Acknowledgments

This package was inspired by the work of [Thomas J.
Leeper](https://github.com/leeper) on the
[cloudyr/circleci](https://github.com/cloudyr/circleci) package.
