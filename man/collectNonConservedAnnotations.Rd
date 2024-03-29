% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/enrichment_funks.R
\name{collectNonConservedAnnotations}
\alias{collectNonConservedAnnotations}
\title{For each species identifies those annotations that are non conserved within
those gene groups (e.g. families) that are indicated by \code{group.ids}.
Non conservation is inferred by
\code{nonConservedCompositeAnnotations(...)}.}
\usage{
collectNonConservedAnnotations(genes.df, group.col = "Tandem.Cluster",
  group.ids = unique(genes.df[, group.col]), gene.annos = all.ipr,
  annos.gene.col = 1, annos.anno.col = 2)
}
\arguments{
\item{genes.df}{A data.frame with three columns, two of which need to be
named 'Gene' and 'Species'. The first column needs to hold the gene-group
IDs.}

\item{group.col}{Identifies the column of \code{genes.df} in which to lookup
gene-group-identifiers. Default is \code{'Tandem.Cluster'}.}

\item{group.ids}{Vector holding indicating in which gene-groups to look for
non conserved composite annotations. Default is \code{unique(genes.df[,
group.col])}.}

\item{gene.annos}{The data.frame holding the annotations for the genes in
'gene.accs'. Default is all available InterPro annotations expected to be
found in 'all.ipr'}

\item{annos.gene.col}{The column of \code{gene.annos} in which to lookup the gene
identifiers or gene accessions. Default is 1}

\item{species}{The species for which to identify non conserved composite
annotations. Default is \code{unique(genes.df$Species)}.}

\item{anno.col}{the column of \code{gene.annos} in which to lookup the function
annotation for the genes in 'gene.accs'. Default is 2}
}
\value{
A data.frame with four columns: 1. The names of the gene-groups, 2.
Species, 3.  genes, and 4. the non conserved annotations (now
non-composite!).
}
\description{
For each species identifies those annotations that are non conserved within
those gene groups (e.g. families) that are indicated by \code{group.ids}.
Non conservation is inferred by
\code{nonConservedCompositeAnnotations(...)}.
}
