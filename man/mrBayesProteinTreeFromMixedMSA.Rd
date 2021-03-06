% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/selection_funks.R
\name{mrBayesProteinTreeFromMixedMSA}
\alias{mrBayesProteinTreeFromMixedMSA}
\title{Generates a valid input file for Mr Bayes, which will generate a Bayesian
phylogeny from a multiple amino acid sequence alignment AND an alignment of
additional e.g. morphological data.}
\usage{
mrBayesProteinTreeFromMixedMSA(aa.msa, extra.msa, mr.bayes.dir,
  gene.group.name, mr.bayes.n.chains = getOption("mc.cores", 4))
}
\arguments{
\item{aa.msa}{an instance of Biostrings::AAStringSet representing the MSA}

\item{extra.msa}{a mamed list of additional e.g. morphological data,
aligned. Names have to be identical with names of 'aa.msa'.}

\item{mr.bayes.dir}{a valid file path to the output directory in which to
store the Mr Bayes analysis related files}

\item{gene.group.name}{the name of the group of proteins to generate the
Bayesian tree for}

\item{mr.bayes.n.chains}{number of chains to use in Mr. Bayes, default is
'mc.cores' or 4, if 'mc.cores' is not set.}
}
\description{
Generates a valid input file for Mr Bayes, which will generate a Bayesian
phylogeny from a multiple amino acid sequence alignment AND an alignment of
additional e.g. morphological data.
}
