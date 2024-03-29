% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/expression_funks.R
\name{maxValuesFromInterVsIntraSpeciesExpressionProfileDists}
\alias{maxValuesFromInterVsIntraSpeciesExpressionProfileDists}
\title{Generates a data.frame with one row for each family with expression profile
distance measurements and columns the maximum distances found for intra-,
inter-species, and all pairwise distances.}
\usage{

  maxValuesFromInterVsIntraSpeciesExpressionProfileDists(fams.inter.intra.exp.prof.dists,
  family.names = names(fams.inter.intra.exp.prof.dists))
}
\arguments{
\item{fams.inter.intra.exp.prof.dists}{The result of invoking function
\code{interVsIntraSpeciesExpressionProfileDists}.}

\item{family.names}{The names of those families to generate rows in the
result data frame. Set to all families that actually have non NA results in
\code{fams.inter.intra.exp.prof.dists}. Default is
\code{names(fams.inter.intra.exp.prof.dists)}.}
}
\value{
An instance of \code{data.frame} with one row for each family in
argument \code{family.names} and columns holding the maximum values
explained above.
}
\description{
Generates a data.frame with one row for each family with expression profile
distance measurements and columns the maximum distances found for intra-,
inter-species, and all pairwise distances.
}
