#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)

if (length(args) < 1) {
  stop("Usage: script.R <input_file>")
}

input_file <- args[1]

# Read and print file contents
if (!file.exists(input_file)) {
  stop(paste("File does not exist:", input_file))
}

print("Printing the contents of the file using R")

lines <- readLines(input_file)
cat(paste(lines, collapse = "\n"), "\n")
