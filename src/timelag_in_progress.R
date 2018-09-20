
# below is a pre-study for writing a function for RTlags

# where b is retweet sample and a is the whole dataset

b %>% 
  sample_n(100) %>% 
  View()

# select a retweeted tweet
b %>% 
  filter(retweeted_status.id_str=="899745826003496961") %>% 
  View()

# see how many retweets in the dataset
a %>% 
  filter(retweeted_status.id_str=="899745826003496961") %>%  #174
  mutate(date_time= lubridate::as_datetime(timestamp_ms/1000)) %>% 
  select(date_time) %>% View()
# see if original tweet is in the dataset

a %>% 
  filter(id_str=="899745826003496961") #yes, its here