# Circle CI HTTP Requests

Workhorse function for executing API requests to Circle CI.

## Usage

``` r
circle(
  verb = "GET",
  path = "",
  query = list(),
  body = "",
  api_version = "v2",
  encode = "json"
)
```

## Arguments

- verb:

  `[character]`  
  A character string containing an HTTP verb, defaulting to `GET`.

- path:

  `[character]`  
  A character string with the API endpoint (should begin with a slash).

- query:

  `[character]`  
  A list specifying any query string arguments to pass to the API. This
  is used to pass the API token.

- body:

  `[character]`  
  A named list or array of what should be passed in the request.
  Corresponds to the "-d" argument of the `curl` command.

- api_version:

  `[character]`  
  A character string specifying the Circle CI API version. This usually
  does not need to be changed by the user.

- encode:

  `[character]`  
  Encoding format. See
  [httr::POST](https://httr.r-lib.org/reference/POST.html).

## Value

An object of class `circle_api` with the following elements

- `content` (queried content)

- `path` (API request)

- `response` (HTTP response information)

## Details

In almost all cases, users should not need to execute API calls
directly. However, if desired this functions makes it possible to issue
any API request. If you experience calling a custom request heavily,
consider opening a feature request on GitHub.

## Examples

``` r
if (FALSE) { # \dontrun{
circle(verb = "GET", path = "/project/gh/ropensci/circle/checkout-key")
} # }
```
