# circle 0.2.0.9000

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
