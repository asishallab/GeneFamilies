% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/family_funks.R
\name{testAnnotationBasedSpeciesSpecificNeofunctionalization}
\alias{testAnnotationBasedSpeciesSpecificNeofunctionalization}
\title{Statistically tests the NULL Hypotheses that the annotation (function) based
species specific Shannon Entropy found in the gene groups for
'spec.2.compare' is not greater than that of the other species. The
population means are compared using a t.test and the whole distributions are
compared using a Kolmogoroff Smirnoff test. Correction for multiple
hypotheses testing is carried out using the 'BY' method (see base::p.adjust
for more details).}
\usage{
testAnnotationBasedSpeciesSpecificNeofunctionalization(entropy.df,
  spec.2.compare, other.specs)
}
\arguments{
\item{entropy.df}{The result of calling function
\code{computeSpeciesSpecificAnnotationDiversityPerGroup(...)}}

\item{spec.2.compare}{The species which to compare to all others.}

\item{other.specs}{The species to compare pairwisely with
\code{spec.2.compare}}
}
\value{
An instance of base::data.frame with 4 columns. The first two
indicate which two species are compared in the respective row, the 3rd
column holds the P-Values obtained from the pairwise T-Test, and the 4th
column the P-Value obtained from the KS-Test. All P-Values are corrected for
multiple hypotheses testing.
}
\description{
Statistically tests the NULL Hypotheses that the annotation (function) based
species specific Shannon Entropy found in the gene groups for
'spec.2.compare' is not greater than that of the other species. The
population means are compared using a t.test and the whole distributions are
compared using a Kolmogoroff Smirnoff test. Correction for multiple
hypotheses testing is carried out using the 'BY' method (see base::p.adjust
for more details).
}
