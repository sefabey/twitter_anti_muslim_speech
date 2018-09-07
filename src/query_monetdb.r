
# load packages 
library(tidyverse)
library(MonetDBLite)
library(DBI)

#start an empty Monet Database
dbdir <- "Desktop/filtered_muslim_islam/muslim_mongo_database" #directory of the Monet database, should be empty
con <- dbConnect(MonetDBLite::MonetDBLite(), dbdir)

dbExistsTable(con, "muslim")
dbListTables(con)


microbenchmark::microbenchmark( (tbl(con,"muslim") %>% 
  select(timestamp_ms) %>% 
  collect()),times = 1) #115390407 tweets

a <- tbl(con,"muslim") %>% 
  select(text_long,timestamp_ms) %>% 
  filter( str_to_lower(text_long) %like% "%muslim%" %OR% str_to_lower(text_long) %like% "%muslim%") %>% 
  collect()

a %>% 
  mutate(a=as.POSIXct(timestamp_ms/1000, origin = "1970-01-01", tz = "GMT")) %>% 
  


dplyr::show_query()
b<-tbl(con,"muslim") %>% 
  select(text_long,timestamp_ms) %>% 
  filter(t) %>% 
  collect()

d<- rbind(a,b)

d %>% 
  filter(str_detect(text_long, regex()))

b %>% sample_n(100) %>% View()
