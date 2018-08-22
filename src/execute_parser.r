library(tidyverse)
source("src/parse_jsonl.r")

input_path <- "data/test_jsonl"
# output_path <- "data/csvs/"
files <- list.files(input_path,full.names = T)
files

parallel::mclapply(X = files, FUN = safely(parse_jsonl), mc.cores=3)

