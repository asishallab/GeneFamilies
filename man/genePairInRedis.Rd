% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/pairwiseKaKs.R
\name{genePairInRedis}
\alias{genePairInRedis}
\title{Checks wether in the current Redis server there is an entry for gene pair
'gene.pair'}
\usage{
genePairInRedis(gene.pair)
}
\arguments{
\item{Character}{vector of length two holding members A and B of the gene
pair.}
}
\value{
Boolean. TRUE of and only if the alphabetically sorted gene
accessions 'A_B' appear in the Redis store.
}
\description{
Checks wether in the current Redis server there is an entry for gene pair
'gene.pair'
}
