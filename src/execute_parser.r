library(tidyverse)
source("src/parse_jsonl.r")

input_path <- "data/"
# output_path <- "data/csvs/"
files <- list.files(input_path,full.names = T)
files

parallel::mclapply(X = files[2], FUN = parse_jsonl, mc.cores=3)

