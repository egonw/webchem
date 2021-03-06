% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ppdb.R
\name{ppdb_buildidx}
\alias{ppdb_buildidx}
\title{Query PPDB search index}
\usage{
ppdb_buildidx()
}
\value{
A dataframe with 2 variables:
\describe{
  \item{cas}{string}
  \item{link}{matched link}
  ...
}
}
\description{
This function queries the PPDB search index \url{http://sitem.herts.ac.uk/aeru/iupac/search.htm} and
is used to get an updated index.
This is used to build the index shipped with the webchem package - code{\link{ppdb_idx}}.
}
\note{
There should be no need to use this function.
Only use this to retrieve an updated index.
}
\examples{
\dontrun{
# code used the build the index shipped with etox
ppdb_idx <- ppdb_buildidx()
}
}
\author{
Eduard Szoecs, \email{eduardszoecs@gmail.com}
}
\seealso{
\code{\link{ppdb_idx}}
}

