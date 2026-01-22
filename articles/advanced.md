# Advanced usage and {tic} integration

## Overview

This vignette covers advanced workflows with {circle} and how to
integrate them with {tic}. It assumes you have completed the basics in
the “Getting Started” vignette.

## Advanced API usage

### Pipelines, workflows, and jobs

Use the high-level helpers to browse recent activity and drill down into
details.

``` r

# list recent pipelines for a repo
circle::get_pipelines(owner = "ropensci", repo = "circle")

# list workflows of a given pipeline id
# (replace with a pipeline id from the previous result)
circle::get_workflows(pipeline_id = "<pipeline-id>")

# list jobs of a workflow
circle::get_jobs(workflow_id = "<workflow-id>")
```

### Restarting and retrying

``` r

# trigger a new build (pipeline) for a branch
circle::new_build(branch = "main")

# retry a workflow (if supported by the API)
circle::retry_workflow(workflow_id = "<workflow-id>")
```

### Artifacts and logs

``` r

# list and download build artifacts
arts <- circle::get_build_artifacts(job_number = 123)
arts
```

### Environment variables

``` r

# read and set environment variables in a project context
circle::get_env_vars(owner = "ropensci", repo = "circle")
circle::set_env_var(owner = "ropensci", repo = "circle", name = "MY_TOKEN", value = "***")
```

## Deep integration with {tic}

The [{tic}](https://docs.ropensci.org/tic/) package provides a
CI-agnostic DSL and ready-made templates for CircleCI. Combine {circle}
(API client) with {tic} (workflow setup) to automate checks and
deployments.

### Initialize CircleCI with {tic}

``` r

# writes .circleci/config.yml and a tic.R with sensible defaults
tic::use_circle_yml()

# or go through the interactive wizard
tic::use_tic()
```

### Customize stages

Edit `tic.R` to add or modify stages. For example, enable pkgdown
deployment only on tags:

``` r

if (ci_has_env("BUILD_PKGDOWN") && tic::on_tag()) {
  get_stage("deploy") %>>% {
    tic::step_do_call("pkgdown::build_site")
    tic::step_do_call("tic::do_pkgdown")
  }
}
```

### Authentication and permissions

For deployments, set up a user key once using {circle}:

``` r

circle::use_circle_deploy()
```

This adds a user key on CircleCI and registers the corresponding key in
your GitHub account, so that
[`tic::deploy()`](https://docs.ropensci.org/tic/reference/stages.html)
can push the pkgdown site to `gh-pages`.

### Making vignettes robust on CI/CRAN

Ensure vignettes build in non-interactive environments by guarding heavy
code (already enabled at the top of this vignette):

``` r

knitr::opts_chunk$set(
  eval = !identical(Sys.getenv("CI"), "true") && !identical(Sys.getenv("CRAN"), "true")
)
```

## See also

- Getting Started (introductory guide)
- Using {circle} with {tic} (step-by-step setup walkthrough)
