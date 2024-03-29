% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/family_funks.R
\name{extractFamilyName}
\alias{extractFamilyName}
\title{Given a character vector regular expressions are applied to extract
substrings of the type 'fam1234'.}
\usage{
extractFamilyName(char.vec)
}
\arguments{
\item{char.vec}{A vector of strings each containing a family name, e.g. file
paths like 'families/fam1234/fam1234_ml_tree.newick'}
}
\value{
a character vector of extracted family names
}
\description{
Given a character vector regular expressions are applied to extract
substrings of the type 'fam1234'.
}
