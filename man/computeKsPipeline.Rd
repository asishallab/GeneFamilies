% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/pairwiseKaKs.R
\name{computeKsPipeline}
\alias{computeKsPipeline}
\title{Runs the pipeline to compute the Ks values of gene pair 'x' with coding
sequences held in 'cds'. Temporary files are stored in 't.d'. Disclaimer:
This function will only work on *nix Operating Systems with 'codeml' and
'tail' installed.}
\usage{
computeKsPipeline(gene.a, gene.b, cds = all.cds,
  t.d = file.path(tempdir(), paste(gene.a, gene.b, sep = "_")),
  codeml.call = getOption("GeneFamilies.codeml.call", "codeml"))
}
\arguments{
\item{gene.a}{A string holding the gene identifier as present in argument
\code{cds}.}

\item{gene.b}{A string holding the gene identifier as present in argument
\code{cds}.}

\item{cds}{an instance of \code{base::list} as generated by
\code{seqinr::read.fasta} holding the unaligned coding sequences of the
genes in 'x'. Default is \code{GeneFamilies::all.cds}.}

\item{t.d}{the directory to store the files in, default is tempdir()
appended with \code{paste( gene,a, gene.b, collapse='_' )}}

\item{codeml.call}{the call passed to system(...) in order to start codeml.
Default is 'codeml', use option 'GeneFamilies.codeml.call' to set another
default.}
}
\value{
A list of three named numeric values: 'Ka', 'Ks', and 'w'. The first
two are parsed from the codeml output file and the latter is computed as
\code{Ka/Ks}.
}
\description{
Runs the pipeline to compute the Ks values of gene pair 'x' with coding
sequences held in 'cds'. Temporary files are stored in 't.d'. Disclaimer:
This function will only work on *nix Operating Systems with 'codeml' and
'tail' installed.
}
\references{
Yang, Z. and Nielsen, R. (2000) Mol. Biol. Evol., 17, 32-43.
}
