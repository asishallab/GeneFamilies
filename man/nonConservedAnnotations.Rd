% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/enrichment_funks.R
\name{nonConservedAnnotations}
\alias{nonConservedAnnotations}
\title{Identifies those gene annotations that are non conserved within the argument
gene-group. Non conserved is inferred as those annotations that do not
appear or miss from the most frequent composite annotation.}
\usage{
nonConservedAnnotations(gene.accs, gene.annos = all.ipr, gene.col = 1,
  anno.col = 2, rm.genes.without.annos = TRUE)
}
\arguments{
\item{gene.accs}{Character-Vector of gene-IDs.}

\item{gene.annos}{A data.frame of gene annotations}

\item{gene.col}{The column of \code{gene.annos} in which to lookup the gene
IDs. Default is 1}

\item{anno.col}{The column of \code{gene.annos} in which to lookup the gene
annotations. Default is 2}

\item{rm.genes.without.annos}{If set to TRUE genes without any annotation
are ignored, otherwise this will cause all conserved annotations to appear
in the result. Default is TRUE}
}
\value{
A data.frame with two columns: 'Gene' holds the gene identifiers of
genes that have non conserved annotations, and column
'Non.Conserved.Annotation' holds the respective annotations.
}
\description{
Identifies those gene annotations that are non conserved within the argument
gene-group. Non conserved is inferred as those annotations that do not
appear or miss from the most frequent composite annotation.
}
