# circle 0.4.0.9000

## Major

- Add new authentication mechanism: `browse_circle_token()` to to query the API token and store it in an env variable `R_CIRCLE` as an alternative method to store it in `~/.circleci/cli.yml`
- Remove `auth_travis()`
- Rename `circleHTTP()` to `circle()`
- add `github_repo()`
- `get_pipelines()` is now formatted as class `circle_builds`, `circle_collection()` and has a somewhat pretty print output

## Bugfixes

- Pipelines without a workflow ID caused `get_builds()` to error. Now pipelines without a workflow ID are removed internally before continuing. 

# circle 0.4.0

- update "cache" function with new user/owner logic from v0.3.0
- new `has_checkout_key()` to check if a specific checkout key exists in the project

# circle 0.3.0

- Rename argument `project` to `repo` to stay consistent with _travis_ pkg.

- Add Github helper functions to easily query owners and users for the repository operating on. This change requires the _git2r_ package from now on.

# circle 0.2.0

- Fix `api_version` in `create_ssh_key()`
- rename `ssh_key*` functions to `checkout_key*`
- `create_checkout_key()` change default for arg `type` from "github-user-key" to "deploy-key"
- add argument `encode` to `circleHTTP()`
- add `use_circle_deploy()`

# circleci 0.1.0

* First working version
