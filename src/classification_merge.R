# merging classification results with =====

retweets_classified <- list.files("/home/datalab3/Desktop/filtered_muslim_islam/classification_results/Retweets", full.names = T) %>% 
  map_df(read_csv) # this does not seem to match nrow of the retweets dataset I exported. 
                   # Possibly an issue with java's print csv method 
                   # i.e. ineffective ',' handling, possibly causing text to drop down
                   # inspecting smaller chunks

rt_chunk_1 <- read_csv("/home/datalab3/Desktop/filtered_muslim_islam/classification_prep/retweets/retweets_chunk_1.csv")
rt_chunk_1 %>%   nrow() #1M

rt_classified <- read_csv("/home/datalab3/Desktop/filtered_muslim_islam/classification_results/Retweets/retweets_chunk_1.csv")
rt_classified %>% nrow() #1006372 row counts don't match

rt_chunk_1 %>% colnames()
rt_classified %>% colnames() # retweeted_status.id_str is missing. at least tweet text colnames match. 


# trying to join results using text as key (though seriously doubt this will work)
rt_chunk_1 %>% left_join(rt_classified, by = "text_long")
#returns 1731575 rows, whereas it should have retunred 1000000 rows. joining by text is always a bad idea.



# trying distinct text 

# expecting nrow 28080773 as this was the total number of tweets exported.
# evidencing above statement 
list.files("/home/datalab3/Desktop/filtered_muslim_islam/classification_prep/distinct_text", full.names = T) %>% 
  map_df(read_csv) %>% 
  nrow() # aha, 28080773!

# now checking nrow classification results
list.files("/home/datalab3/Desktop/filtered_muslim_islam/classification_results/Data", full.names = T) %>% 
  map_df(read_csv) %>% 
  nrow() # unfortunately 28146262. joining these results won't work as well.

# lets try with another csv reader
list.files("/home/datalab3/Desktop/filtered_muslim_islam/classification_results/Data", full.names = T) %>% 
  map_df(data.table::fread, quote="\"",stringsAsFactors=FALSE) %>% 
  nrow()

# lets try with another csv reader
list.files("/home/datalab3/Desktop/filtered_muslim_islam/classification_results/Data", full.names = T) %>% 
  map_df(read.csv, stringsAsFactors=FALSE) %>% 
  nrow()


# MO UPDATED CLASSIFICATION RESULTS=====


retweets_classified <- list.files("/home/datalab3/Desktop/filtered_muslim_islam/classification_results/Retweets", full.names = T) %>% 
  map_df(read_csv, col_types="cc") # this does not seem to match nrow of the retweets dataset I exported. 
# Possibly an issue with java's print csv method 
# i.e. ineffective ',' handling, possibly causing text to drop down
# inspecting smaller chunks

rt_chunk_1 <- read_csv("/home/datalab3/Desktop/filtered_muslim_islam/classification_prep/retweets/retweets_chunk_1.csv", col_types = "cc")
rt_chunk_1 %>%   nrow() #1M

rt_classified <- read_csv("/home/datalab3/Desktop/filtered_muslim_islam/classification_results/Retweets/retweets_chunk_1.csv", col_types = "cc")
rt_classified %>% nrow() #999778 rows, not good, should have been 1M 

rt_chunk_1 %>% colnames()
rt_classified %>% colnames() # retweeted_status.id_str is missing. at least tweet text colnames match. 


# trying to join results using text as key (though seriously doubt this will work)
rt_chunk_1 %>% left_join(rt_classified, by = "retweeted_status.id_str") #join returns 1M rows, okay


retweets_joined <- retweets %>% left_join(retweets_classified, by = "retweeted_status.id_str")

retweets_joined %>% summary()

# trying distinct text 

# expecting nrow 28080773 as this was the total number of tweets exported.
# evidencing above statement 
list.files("/home/datalab3/Desktop/filtered_muslim_islam/classification_prep/distinct_text", full.names = T) %>% 
  map_df(read_csv) %>% 
  nrow() # aha, 28080773!

# now checking nrow classification results
list.files("/home/datalab3/Desktop/filtered_muslim_islam/classification_results/Data", full.names = T) %>% 
  map_df(read_csv, col_types="cc") %>% 
  nrow() # unfortunately 28075154. not far off but also not exact.


distinct_tweets_classification<- list.files("/home/datalab3/Desktop/filtered_muslim_islam/classification_results/Data", full.names = T) %>% 
  map_df(read_csv, col_types="cc")



distinct_tweets %>% left_join()
