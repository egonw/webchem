% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/physprop.R
\name{physprop}
\alias{physprop}
\title{Query SRC PHYSPROP Database}
\usage{
physprop(cas, verbose = TRUE)
}
\arguments{
\item{cas}{character; A CAS number to query.}

\item{verbose}{logical; print message during processing to console?}
}
\value{
A list of 4 entries: cas (CAS-Number), cname (Chemical Name),
mw (Molecular weigth) and prop (Properties).
prop is a data.frame, with variables, value, unit, temp, type (see note) and ref (see note).
}
\description{
Query SRCs PHYSPROP Database. The PHYSPROP database contains chemical structures,
names and physical properties for over 41,000 chemicals.
Physical properties collected from a wide variety of sources include experimental,
extrapolated and estimated values. For more information
see \url{http://www.srcinc.com/what-we-do/environmental/scientific-databases.html#physprop}.
}
\note{
Abbreviations in the 'Type' field: EXP = Experimental Data,
EST = Estimated Data, EXT = Extrapolated Data. Extrapolated data is based
upon experimental measurement outside the temperature range of the reported value.
References below are abbreviated citations ...
the full reference citations are NOT available here.
References for Estimated data generally refer to the method used to make the estimate ...
most estimates were made using SRC software.
}
\examples{
\dontrun{
physprop('50-00-0')
lapply(c('50-00-0', '79622-59-6', 'xxxxx'), physprop)
}
}
\author{
Eduard Szoecs, \email{eduardszoecs@gmail.com}
}

