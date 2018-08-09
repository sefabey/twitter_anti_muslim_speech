library(tidyverse)
source("src/parse_jsonl.r")

input_path <- "/media/datalab3/data1/backup_dataset/post-election/jsonl"
# output_path <- "data/csvs/"
files <- list.files(input_path,full.names = T)
files
parallel::mclapply(X = files[1:5], FUN = parse_jsonl, mc.cores=3)

