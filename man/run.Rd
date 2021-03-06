% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/run.R
\name{run}
\alias{run}
\title{Run a .Rmd file}
\usage{
run(x, filename = "code.R", knitopts = list())
}
\arguments{
\item{x}{Input, one of: code wrapped in curly brackets and quotes, a file
path to an .Rmd file, or a gist.}

\item{filename}{Name of the file to create, only used if \code{code}
parameter is used. Default to \code{code.R}}

\item{knitopts}{(list) List of variables passed on to
\code{\link[knitr:knit]{knitr::knit()}}}
}
\value{
A path, unless a gist object is passed in, in which case a gist
object is returned.
}
\description{
Run a .Rmd file
}
\examples{
\dontrun{
# run a local file
file <- system.file("examples", "stuff.Rmd", package = "gistr")
run(file) \%>\% gist_create

# run code
run({'
```{r}
x <- letters
(numbers <- runif(8))
```
'}) \%>\% gist_create

# run a file from a gist, has to get file first
gists('minepublic')[[2]] \%>\% run() \%>\% update()
}
}
