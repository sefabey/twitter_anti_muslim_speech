# load packages 
library(tidyverse)
library(MonetDBLite)
library(DBI) 

#Connect to Monet Database
dbdir <- "~/muslim_islam/muslim_monet_database" #directory of the Monet database, should be empty
con <- dbConnect(MonetDBLite::MonetDBLite(), dbdir)

# check if tables actually exists
dbExistsTable(con, "muslim")
dbListTables(con)

# query column names
muslim_columns <- tbl(con,"muslim") %>% 
  colnames() %>% 
  as.tibble()

# collect all rows and selected columns into memory
a <- tbl(con,"muslim") %>% 
  select(text_long, id_str, timestamp_ms,user.screen_name, quoted_status.id_str, retweeted_status.id_str,in_reply_to_status_id_str) %>% 
  # as.data.frame() %>% 
  # sample_n(100000) %>% 
  # as.tibble() %>% 
  collect()

# filter disctinct tweets by retweeted id str
a %>% 
  distinct(retweeted_status.id_str, .keep_all = T) ->retweets #when joining classification results, use retweeted_status.id_str as key
retweets
# retweets %>% 
  # write_csv("~/Desktop/filtered_muslim_islam/classification_prep/distinct_retweet_id_str.csv")

# filter distinct tweets by text when not retweet
a %>% 
  filter(is.na(retweeted_status.id_str)) %>% 
  distinct(text_long, .keep_all = T) ->distinct_tweets #when joining classification results, use text_long as key
distinct_tweets
# distinct_tweets %>% 
  # write_csv("~/Desktop/filtered_muslim_islam/classification_prep/distinct_text_long.csv")



# MO UPDATED CLASSIFICATION RESULTS=====

# read in classification results

# first retweets
retweets_classified <- list.files("muslim_islam/classification_results/Retweets/", full.names = T) %>% 
  map_df(read_csv, col_types="cc") %>% 
  mutate(classification_result=as.factor(No))%>% 
  select(-No) %>% 
  filter(!is.na(retweeted_status.id_str)) #filtering this NA is very important becuse otherwise it would match all non-retweet as no

retweets_classified %>% 
  nrow()

retweets_classified$retweeted_status.id_str %>% is.na() %>% table()

# then distinct tweets
distinct_classified <- list.files("muslim_islam/classification_results/Data/", full.names = T) %>% 
  map_df(read_csv, col_types="cc") %>% 
  mutate(classification_result=as.factor(No)) %>% 
  select(-No)%>% 
  filter(!is.na(id_str)) 

distinct_classified %>% 
  nrow()

distinct_classified$id_str %>% is.na() %>% table()

# joining with 
retweets_merged <- retweets %>% left_join(retweets_classified)
distinct_merged <- distinct_tweets %>% left_join(distinct_classified)

# checking classification counts
retweets_merged %>% 
  mutate(classification_result=as.factor(classification_result)) %>% 
  summary()

distinct_merged %>% 
  mutate(classification_result=as.factor(classification_result)) %>% 
  summary()

rm(retweets_merged)
rm(distinct_merged)

# now big moment, merging classification results with large dataset

a <- a %>% 
  left_join(retweets_classified, by=c("retweeted_status.id_str"="retweeted_status.id_str")) %>% 
  left_join(distinct_classified, by=c("id_str"="id_str")) %>% 
  mutate(is_hate=coalesce(classification_result.x, classification_result.y))

a %>% summary
  
# filter(retweeted_status.id_str==871132730439983104) check if this is classified 

a %>% 
  filter(id_str==871132730439983104)


a %>% 
  mutate(timestamp=lubridate::as_datetime(timestamp_ms/1000))

# creating an empty MonetDB on local machine
MonetDBLite::monetdblite_shutdown() #shut down existing connection first
dbdir <- "muslim_islam/muslim_monetdb_classified" #directory of the Monet database, should be empty
con <- dbConnect(MonetDBLite::MonetDBLite(), dbdir)

a %>% colnames

a %>% 
  mutate(timestamp=lubridate::as_datetime(timestamp_ms/1000)) %>% 
  select(text_long, id_str, timestamp, user.screen_name, quoted_status.id_str, retweeted_status.id_str, in_reply_to_status_id_str,is_hate) %>% 
  DBI::dbWriteTable(con, "muslim_classified",., append=T) 
