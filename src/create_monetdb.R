# Install necessary packages
install.packages("DBI")
install.packages("MonetDBLite")

# load packages 
library(tidyverse)
library(MonetDBLite)
library(DBI)

#start an empty Monet Database
dbdir <- "../Desktop/temp/monet_db/" #directory of the Monet database, should be empty
con <- dbConnect(MonetDBLite::MonetDBLite(), dbdir)


#read csv files to R objects and then write to database
##just one csv first

temp_data <- read_csv("../Desktop/temp/muslim_csv/filtered_tweets2017-03-20-11-32.csv",col_types = "cccciclc?ddcccciilcccciiiccclciilccilciccclddcccccciiiccciiillccciccclddccciiccciiicccilclccicicccc")

dbWriteTable(con, "muslim",temp_data, append=T) #connection, table name in the database, local tibble

dbReadTable(con,"muslim") %>% 
  select(contains("created_at")) %>% 
  as.tibble() %>% 
  select(created_at)
mutate(created_at_parsed= lubridate::as_datetime(created_at)) %>% 
  select(created_at_parsed, everything())

dbRemoveTable(con, "muslim")

## push multiple csv files 
csv_files <- list.files( "../Desktop/temp/muslim_csv/",full.names = T, recursive = T)
read_and_push_to_db <- function(x){
  temp_data <- read_csv(x,col_types = "cccciclc?ddcccciilcccciiiccclciilccilciccclddcccccciiiccciiillccciccclddccciiccciiicccilclccicicccc")
  dbWriteTable(con, "muslim",temp_data, append=T)
}

map(csv_files,read_and_push_to_db)

dbReadTable(con, "muslim") %>% nrow()
a <- tbl(con, "muslim") %>% head(30000)  %>% collect() %>% sample_n(10)
