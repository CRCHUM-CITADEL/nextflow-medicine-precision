#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)

if (length(args) < 1) {
  stop("Usage: script.R <input_file>")
}

input_file <- args[1]

if (!file.exists(input_file)) {
  stop(paste("File does not exist:", input_file))
}

# write to current working dir using only the basename so Nextflow can capture it
base <- basename(input_file)
output_file <- paste0(base, "_reversed_r.txt")

lines <- readLines(input_file)
writeLines(rev(lines), output_file)

cat("Reversed file saved as:", output_file, "\n")
