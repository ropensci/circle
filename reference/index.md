# Package index

## Authentication

- [`get_circle_user()`](get_circle_user.md) : Get Circle CI user
- [`enable_repo()`](enable_repo.md) : Enable a repo on Circle CI
- [`browse_circle_token()`](browse_circle_token.md) : Authenticate to
  Circle CI
- [`edit_circle_config()`](edit_circle_config.md) : Open circle
  Configuration file

## Builds & Jobs

- [`circle()`](circle.md) : Circle CI HTTP Requests
- [`get_pipelines()`](builds.md) [`get_workflows()`](builds.md)
  [`get_jobs()`](builds.md) [`retry_workflow()`](builds.md) : Retrieve
  Metadata from Circle CI Builds
- [`get_build_artifacts()`](get_build_artifacts.md) : Get Build
  Artifacts of a Specific Job
- [`new_build()`](new_build.md) : Trigger a New Build on Circle CI

## Manage Environment Variables

- [`get_env_vars()`](env_var.md) [`set_env_var()`](env_var.md)
  [`delete_env_var()`](env_var.md) : Interact with Environment
  Variable(s) on Circle CI

## Deployment

- [`use_circle_deploy()`](use_circle_deploy.md) : Set Up Build
  Deployment Between Circle CI And Github

## Manage API Keys

- [`create_checkout_key()`](checkout_key.md)
  [`get_checkout_keys()`](checkout_key.md)
  [`delete_checkout_key()`](checkout_key.md)
  [`has_checkout_key()`](checkout_key.md) : Interact with "Checkout
  Keys" on Circle CI

## Miscellaneous

- [`circle-package`](circle-package.md) : Circle CI API Client
- [`list_projects()`](list_projects.md) : List Circle CI Projects
