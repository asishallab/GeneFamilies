#' Extracts the coding sequences of the gene members of the argument family
#' from this package's database 'all.cds'. Warns, if not all members are found
#' in the database.
#'
#' @param fam - The character vector of gene names member of the family.
#' @param cds - The database of coding sequences as an instance of \code{base::list}
#' [seqinr]. Default is this packages database 'all.cds'.
#'
#' @return An instance of \code{base::list} as generated by
#' \code{seqinr::read.fasta} holding the coding sequences of the argument
#' family.
#' @export
getFamilyDNAStringSet <- function(fam, cds = all.cds) {
    inds <- intersect(names(cds), fam)
    if (length(inds) != length(fam)) 
        warning("Could not find coding sequences for ", paste(setdiff(fam, 
            names(cds)), collapse = ","), " in database 'cds'.")
    cds[inds]
}

#' Uses the program MACSE to translate the coding sequences to amino acid
#' sequences.
#'
#' @param path.2.cds.fasta gives the valid file path to the FASTA file holding
#' the coding sequences.
#' @param macse.call The call with which to invoke MACSE through the
#' system(...) function. Use option 'macse.call' to modify the default.
#'
#' @return TRUE if and only if no error has occurred.
#' @export
translate2AASeqs <- function(path.2.cds.fasta, macse.call = getOption("macse.call", 
    paste("java -Xmx600m -jar ", file.path(path.package("GeneFamilies"), 
        "macse_v1.01b.jar"), " -prog translateNT2AA", sep = ""))) {
    cmd <- paste(macse.call, "-seq", path.2.cds.fasta)
    system(cmd)
    TRUE
}

#' Validates an AAString
#'
#' @param 'aa.seq' an instance of \code{seqinr::SeqFastaAA}
#'
#' @return TRUE if and only if the argument does not have a premature stop
#' codon.
#' @export
validateAASeqs <- function(aa.seq) {
    if (class(aa.seq) != "SeqFastaAA") 
        stop("Argument 'aa.seq' is not of class 'AAString'.")
    !grepl("\\S\\*\\S", aa.seq, perl = TRUE)
}

#' Validates an AAStringSet
#'
#' @param 'aa.seq' an instance of \code{base::list} as generated by
#' \code{seqinr::read.fasta}
#'
#' @return A logical vector indicating the indices of valid AA-Seqs in the argument set.
#' @export
validateAAStringSet <- function(aa.set) {
    as.logical(lapply(names(aa.set), function(acc) {
        tryCatch({
            validateAASeqs(aa.set[[acc]])
        }, error = function(e) {
            warning("Amino-Acid-Sequence ", acc, " caused an error: ", 
                e)
            FALSE
        })
    }))
}

#' Aligns the set of amino acid sequences based on the chemical properties of
#' their respective amino acid residues. Does so using MAFFT. NOTE: mafft is
#' expected to be installed.
#'
#' @param 'path.2.aa.seqs' the valid file path to the amino acid sequences
#' FASTA
#' @param 'path.2.aa.msa' the valid file path to the amino acid multiple
#' sequence alignment file that is to be generated
#' @param 'mafft.call' the string used to build the system command which
#' invokes MAFFT.
#'
#' @return TRUE if and only of no error occurred.
#' @export
alignAAStringSet <- function(path.2.aa.seqs, path.2.aa.msa, mafft.call = getOption("mafft.call", 
    paste("mafft --thread", getOption("mc.cores", 1), "--auto"))) {
    cmd <- paste(mafft.call, path.2.aa.seqs, ">", path.2.aa.msa)
    system(cmd)
    TRUE
}

#' Uses an amino acid multiple sequence alignment to guide the alignment of
#' codon sequence 'cds'.
#'
#' @param 'cds' a String representing the codon sequence to align.
#' @param 'aligned.aa.seq' a String representing the aligned amino acid
#' sequence.
#' @param 'aa.gap' the string used to represent a gap in the aligned AA sequence
#' @param 'codon.gap' the string used to represent a gap in the aligned codon
#' sequence
#'
#' @return A String representing the aligned codon sequence
#' @export
alignCDSWithAlignedAASeq <- function(cds, aligned.aa.seq, aa.gap = "-", 
    codon.gap = "---") {
    aa.chars <- strsplit(toString(aligned.aa.seq), split = NULL)[[1]]
    cds.chars <- strsplit(toString(cds), split = NULL)[[1]]
    i <- 1
    paste(lapply(aa.chars, function(aa.char) {
        if (aa.char == aa.gap) {
            codon.gap
        } else {
            start.ind <- (i - 1) * 3 + 1
            stop.ind <- i * 3
            i <<- i + 1
            paste(cds.chars[start.ind:stop.ind], collapse = "")
        }
    }), collapse = "")
}

#' Uses an amino acid multiple sequence alignment to guide the alignment of
#' codon sequence 'cds'.
#'
#' @param 'unaligned.cds.set' an instance of \code{base::list} as generated by
#' \code{seqinr::read.fasta} representing the unaligned codon sequences
#' @param 'aligned.aa.set' an instance of \code{base::list} as generated by
#' \code{seqinr::read.fasta} representing the aligned amino acid sequences used
#' as guide
#'
#' @return An instance of \code{base::list} with names being the gene
#' accessions and values Strings representing the aligned coding-sequences.
#' @export
alignCDSSetWithAlignedAAsAsGuide <- function(unaligned.cds.set, 
    aligned.aa.set) {
    cds.set <- lapply(names(aligned.aa.set), function(acc) {
        alignCDSWithAlignedAASeq(unaligned.cds.set[[acc]], aligned.aa.set[[acc]])
    })
    names(cds.set) <- names(aligned.aa.set)
    cds.set
}

#' Uses FastTree[MP] to generate a maximum likelihood tree based on sequence
#' profiles. 
#'
#' @param 'path.2.cds.msa' a valid file path to the codon multiple sequence
#' alignment to feed into FastTree[MP]
#' @param 'path.2.ml.tree' a valid file path in which to store the resulting
#' tree in newick format
#' @param 'fast.tree.call' the command whith which to invoke FastTree[MP]
#'
#' @return TRUE if and only if no error occurred.
#' @export
buildPhylogeneticTree <- function(path.2.cds.msa, path.2.ml.tree, 
    fast.tree.call = getOption("fast.tree.call", paste("OMP_NUM_THREADS=", 
        getOption("mc.cores", 1), " FastTreeMP -nt -gtr -gamma", 
        sep = ""))) {
    cmd <- paste(fast.tree.call, "<", path.2.cds.msa, ">", path.2.ml.tree)
    system(cmd)
    TRUE
}

#' Many programs in Bioinformatics cannot handle gene accessions with special
#' characters. That is why we rename the genes in a list as generated by
#' \code{seqinr::read.fasta} with 'PROT1', 'PROT2'...
#'
#' @param 'xstring.set' an instance of base::list as generated by
#' \code{seqinr::read.fasta}
#'
#' @return An instance of data.frame with two columns the 'original' and the
#' 'sanitized' names.
#' @export
sanitizeNames <- function(xstring.set) {
    df <- data.frame(original = names(xstring.set), stringsAsFactors = FALSE)
    df$sanitized <- paste("PROT", 1:nrow(df), sep = "")
    df
}

#' Returns the matching original names for the sanitized ones held in argument
#' 'san.names'.
#'
#' @param 'san.names' a character vector of sanitized names (gene accessions)
#' @param 'name.mappings' a data.frame generated by function
#' 'sanitizeNames(...)'. This data.frame is used to lookup the matching
#' original names for the argument sanitized names.
#'
#' @return A character vector in which the original names are stored in the
#' order of their matching sanitized ones as they appear in the argument
#' 'san.names'.
#' @export
replaceWithOriginal <- function(san.names, name.mappings) {
    as.character(lapply(san.names, function(x) {
        name.mappings[which(name.mappings$sanitized == x), "original"]
    }))
}

#' Identifies the species of a gene identifier using regular expressions. Note
#' that the constant spec.regex.gene.ids is used by default to map regular
#' expression to species. See zzz.R for more details.
#'
#' @param gene.id 
#' @param spec.regexs a list with names indicating the species and values the
#' regular expressions to match gene identifiers against.
#'
#' @return the matching species as a name in argument list 'spec.regexs'
#' @export
speciesForGeneId_Regex <- function(gene.id, spec.regexs = spec.regex.gene.ids) {
    y <- ""
    for (s.r.n in names(spec.regexs)) {
        s.r <- spec.regexs[[s.r.n]]
        if (grepl(s.r, gene.id, perl = TRUE)) {
            y <- s.r.n
            break
        }
    }
    y
}

#' Identifies the species of a gene identifier using the original gene
#' identifiers in this project's data sets. Note that the constant
#' spec.gene.ids is used by default to map gene identifiers to species. See
#' zzz.R for more details.
#'
#' @param gene.id 
#' @param spec.genes A names list, in which the names indicate the species and
#' the values are character vectors of gene identifiers.
#'
#' @return the matching species as a name in argument list 'spec.regexs'
#' @export
speciesForGeneId <- function(gene.id, spec.genes = spec.gene.ids) {
    y <- ""
    for (s.n in names(spec.genes)) {
        s.g <- spec.genes[[s.n]]
        if (gene.id %in% s.g) {
            y <- s.n
            break
        }
    }
    y
}

#' For a default phylogentic tree this formats the local support values for
#' printing.
#'
#' @param nd.lb the character vector of node labels of an instance of class
#' ape::phylo
#'
#' @return a formatted character vector to be used as a replacement for the
#' original node labels
#' @export
formatNodeLabels <- function(nd.lb) {
    y <- round(as.numeric(nd.lb), digits = 2)
    y[is.na(y) | y == 0] <- ""
    y[y == "1"] <- "1.0"
    sub("0.", ".", y, fixed = TRUE)
}

#' Identifies a list of sub-trees in argument tree initiating from the the
#' argument nodes and maps those sub-trees on their contained tips.
#'
#' @param tree an instance of class ape::phylo
#' @param nds the inner nodes for which to identify the sub-trees 
#'
#' @return A named list. Names are the argument tips and values the node label
#' of the root node of the sub-tree.
#' @export
subTrees <- function(tree, nds = unique(tree$edge[, 1])) {
    lst <- list()
    lapply(nds, function(x) {
        x.tips <- Descendants(tree, x, type = "tips")[[1]]
        x.tip.lbls <- paste(sort(tree$tip.label[x.tips]), collapse = ",")
        lst[x.tip.lbls] <<- tree$node.label[x - length(tree$tip.label)]
    })
    lst
}

#' Passes support values from inner nodes in argument 'trees' to matching inner
#' nodes in argument 'tree', if and only if the respective inner nodes span a
#' subtree terminating in identical sets of tips. Note, that the inner topology
#' is ignored.
#'
#' @param tree an instance of class ape::phylo
#' @param trees a vector of instances of class ape::phylo
#' @param nds an integer vector indicating inner nodes of the argument 'tree'
#' to process
#'
#' @return An annotated copy of argument 'tree'
#' @export
passSupportValues <- function(tree, trees, nds = unique(tree$edge[, 
    1])) {
    sub.trees <- lapply(trees, subTrees)
    tr <- tree
    if (!"node.label" %in% names(tr)) 
        tr$node.label <- character(tr$Nnode)
    for (n in nds) {
        for (i in 1:length(sub.trees)) {
            x <- paste(sort(tr$tip.label[Descendants(tree, n, 
                type = "tips")[[1]]]), collapse = ",")
            y <- sub.trees[[i]]
            if (x %in% names(y)) {
                k <- n - length(tr$tip.label)
                sup.name <- names(sub.trees)[[i]]
                tr$node.label[[k]] <- paste(c(tr$node.label[[k]], 
                  paste(sup.name, y[[x]], sep = "")), collapse = "_")
            }
        }
    }
    tr
}

#' Runs the pipeline to align a set of coding sequences: First translates them,
#' then validates them for premature stop codons, subsequently generates a
#' multiple sequence alignment (MSA) of amino acid (AA) sequences, then uses
#' this AA MSA as guide and aligns the coding sequences in the final step.
#'
#' @param cds an instance of \code{base::list} as generated by
#' \code{seqinr::read.fasta} representing the coding sequences that need to be
#' aligned
#' @param work.dir the working directory to use and in which to save the
#' relevant files
#' @param gene.group.name a string being used to name the output files written
#' into work.dir. Could be something like 'fam1234'.
#'
#' @export
#' @return The ALIGNED and validated coding sequences as an instance of
#' \code{base::list} as generated by \code{seqinr::read.fasta}, or nothing if
#' validation discards the rest of 'cds'.
alignCodingSequencesPipeline <- function(cds, work.dir, gene.group.name) {
    #' Sanitize the gene identifiers:
    name.maps <- sanitizeNames(cds)
    names(cds) <- name.maps$sanitized
    cds.path <- file.path(work.dir, paste(gene.group.name, "_CDS.fasta", 
        sep = ""))
    write.fasta(sequences = cds, names = names(cds), file.out = cds.path)
    name.maps.path <- file.path(work.dir, paste(gene.group.name, 
        "_name_mappings_table.txt", sep = ""))
    write.table(name.maps, name.maps.path, row.names = FALSE, 
        sep = "\t", quote = FALSE)
    #' Convert to AA and align the AA-sequences:
    translate2AASeqs(cds.path)
    #' Remove invalid AA-Sequences, i.e. AA-Seqs with premature stop-codons:
    aa.path <- file.path(work.dir, paste(gene.group.name, "_CDS_macse_AA.fasta", 
        sep = ""))
    aas <- read.fasta(aa.path, seqtype = "AA", as.string = TRUE, 
        strip.desc = TRUE)
    aas.san <- aas[validateAAStringSet(aas)]
    #' Warn about removed AA-Seqs:
    cds.san <- if (length(aas.san) < length(aas)) {
        len.diff <- length(aas) - length(aas.san)
        warning(len.diff, " amino-acid-sequences had a premature stop codon and were removed from further analysis.")
        cds[names(aas.san)]
    } else cds
    #' If only a single sequence is left, we're done:
    cds.msa.orig <- if (length(cds.san) > 1) {
        #' Write out the sanitized amino acid seqs:
        aas.san.path <- file.path(work.dir, paste(gene.group.name, 
            "_AA_sanitized.fasta", sep = ""))
        write.fasta(sequences = aas.san, names = names(aas.san), 
            file.out = aas.san.path)
        #' Generate a multiple sequence alignment:
        aas.msa.path <- file.path(work.dir, paste(gene.group.name, 
            "_AA_sanitized_MSA.fasta", sep = ""))
        alignAAStringSet(aas.san.path, aas.msa.path)
        aas.san.msa <- read.fasta(aas.msa.path, seqtype = "AA", 
            as.string = TRUE, strip.desc = TRUE)
        #' Use the aligned AA-Seqs as quide to align the CDS Sequences:
        cds.msa <- alignCDSSetWithAlignedAAsAsGuide(cds.san, 
            aas.san.msa)
        cds.msa.path <- file.path(work.dir, paste(gene.group.name, 
            "_CDS_MSA.fasta", sep = ""))
        write.fasta(sequences = cds.msa, names = names(cds.msa), 
            file.out = cds.msa.path)
        cds.msa
    } else {
        cds.san
    }
    #' Return the CDS MSA using the ORIGINAL gene identifiers:
    if (length(cds.msa.orig) > 0) 
        names(cds.msa.orig) <- replaceWithOriginal(names(cds.msa.orig), 
            name.maps)
    cds.msa.orig
}

#' Identifies those entries in argument \code{seq.lst} that have identical
#' names as argument \code{seq.names}. If for not all members of
#' \code{seq.names} entries are found in \code{seq.lst} the function tries to
#' match those sequence names that were not found with sequence names in
#' \code{seq.lst} by allowing for splice variants. E.g. \code{GeneA} is not
#' found in \code{seq.lst}, but \code{GeneA.1} might be.
#'
#' @param seq.lst An instance of \code{base::list} holding biological sequences
#' indexed by their unique names (IDs).
#' @param seq.names A character vector of sequence IDs to select from argument
#' \code{seq.lst}.
#' @param ... Additional arguments to be passed to \code{base::grepl} can be
#' e.g. \code{ignore.case = TRUE}.
#'
#' @export
#' @return An instance of \code{base::list} the subset of argument
#' \code{seq.lst} whose entries match the sequence IDs given in
#' \code{seq.names}.
getSpliceVariantSeqs <- function(seq.lst, seq.names, ...) {
    seq.selected <- seq.lst[which(names(seq.lst) %in% seq.names)]
    if (length(seq.selected) < length(unique(seq.names))) {
        try.splice.vars <- setdiff(seq.names, names(seq.lst))
        tsv.i <- unique(unlist(lapply(try.splice.vars, function(x) {
            which(grepl(paste0("^", x, "\\.\\d+$"), names(seq.lst), 
                ...))
        })))
        if (length(tsv.i) > 0) {
            seq.selected <- append(seq.selected, seq.lst[tsv.i])
        }
    }
    seq.selected
}
