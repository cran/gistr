#' Authorize with GitHub.
#'
#' This function is run automatically to allow gistr to access your GitHub 
#' account.
#'
#' There are two ways to authorise gistr to work with your GitHub account:
#' 
#' - Generate a personal access token with the gist scope selected, and set it
#' as the `GITHUB_PAT` environment variable per session using `Sys.setenv`
#' or across sessions by adding it to your `.Renviron` file or similar.
#' See
#' https://help.github.com/articles/creating-an-access-token-for-command-line-use
#' for help
#' - Interactively login into your GitHub account and authorise with OAuth.
#'
#' Using `GITHUB_PAT` is recommended.
#'
#' @export
#' @param app An [httr::oauth_app()] for GitHub. The default uses an 
#' application `gistr_oauth` created by Scott Chamberlain.
#' @param reauth (logical) Force re-authorization?
#' @examples \dontrun{
#' gist_auth()
#' }

gist_auth <- function(app = gistr_app, reauth = FALSE) {
 
  if (exists("auth_config", envir = cache) && !reauth) {
    return(undo(cache$auth_config$headers))
  }
  pat <- Sys.getenv("GITHUB_PAT", "")
  if (!identical(pat, "")) {
    auth_config <- httr::add_headers(Authorization = paste0("token ", pat))
  } else if (!interactive()) {
    stop("In non-interactive environments, please set GITHUB_PAT env to a GitHub",
         " access token (https://help.github.com/articles/creating-an-access-token-for-command-line-use)",
         call. = FALSE)
  } else  {
    endpt <- httr::oauth_endpoints("github")
    token <- httr::oauth2.0_token(endpt, app, scope = "gist", cache = !reauth)
    auth_config <- httr::config(token = token)
  }
  cache$auth_config <- auth_config
  undo(auth_config$headers)
}

undo <- function(x) unclass(as.list(unclass(x)))

cache <- new.env(parent = emptyenv())

gistr_app <- httr::oauth_app(
  "gistr_oauth",
  "89ecf04527f70e0f9730",
  "77b5970cdeda925513b2cdec40c309ea384b74b7"
)
