# load packages 
library(tidyverse)
library(MonetDBLite)
library(DBI)

#Connect to Monet Database
dbdir <- "~/Desktop/filtered_muslim_islam/muslim_monet_database/" #directory of the Monet database, should be empty
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
  collect()

# filter disctinct tweets by retweeted id str
a %>% 
  distinct(retweeted_status.id_str, .keep_all = T) ->retweets #when joining classification results, use retweeted_status.id_str as key
retweets %>% head()
retweets %>% 
  write_csv("~/Desktop/filtered_muslim_islam/classification_prep/distinct_retweet_id_str.csv")

# filter distinct tweets by text when not retweet
a %>% 
  filter(is.na(retweeted_status.id_str)) %>% 
  distinct(text_long, .keep_all = T) ->distinct_tweets #when joining classification results, use text_long as key

distinct_tweets %>% 
  write_csv("~/Desktop/filtered_muslim_islam/classification_prep/distinct_text_long.csv")

# When the classification task is complete, the results would be joined with the larger dataset.
# this would happen in two iterations.
# when joinining distinct by rt.id_str and distinct by text_long, the joined columns might clash.
# need to account for it.

# create small chunks=====

##retweets as key=====
n <- 1000000
nr <- nrow(retweets)

retweet_splits <- retweets %>% 
  select(text_long,retweeted_status.id_str) %>% 
  split( rep(1:ceiling(nr/n), each=n, length.out=nr)) 

map(names(retweet_splits), ~write_csv(retweet_splits[[.]], paste0("~/Desktop/filtered_muslim_islam/classification_prep/retweets_chunk_",.,".csv")))

# text_long as key=====
n <- 1000000
nr <- nrow(distinct_tweets)
distinct_tweets_splits <- distinct_tweets %>% 
  select(text_long,id_str) %>% 
  split( rep(1:ceiling(nr/n), each=n, length.out=nr)) 

map(names(distinct_tweets_splits), ~write_csv(distinct_tweets_splits[[.]], paste0("~/Desktop/filtered_muslim_islam/classification_prep/distinct_text/distinct_text_chunk_",.,".csv")))



