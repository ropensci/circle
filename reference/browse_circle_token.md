# Authenticate to Circle CI

A Circle CI API token is needed to interact with the Circle CI API.
`browse_circle_token()` opens a browser window for the respective Circle
CI endpoint to retrieve the key.

## Usage

``` r
browse_circle_token()
```

## Value

Returns `TRUE` (invisibly).

## Store API token

`circle` supports two ways of storing the Circle API tokens:

- via env vars `R_CIRCLE`

- via `~/.circleci/cli.yml`

The latter should already be present if you already used the `circle`
CLI tool at some point in the past. If not, its up to your preference
which approach to use.

The following instructions should help to set up `~/.circleci/cli.yml`
correctly:

1.  Copy the token from the browser after having called
    `browse_circle_token()`. You can use
    [`edit_circle_config()`](edit_circle_config.md) to open
    `~/.circleci/cli.yml`.

2.  The token should be stored using the following structure

        host: https://circleci.com
        endpoint: graphql-unstable
        token: <token>

## Examples

``` r
if (FALSE) { # \dontrun{
browse_circle_token()

edit_circle_config()
} # }
```
