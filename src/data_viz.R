library(tidyverse)
library(lubridate)
library(scales)

# read and wrangle dataset
hourly_tweet_counts <- read_csv("../Desktop/temp/hourly_tweet_counts.csv")%>% 
  mutate(date_time=str_extract(file, regex("(?=tweets).+"))) %>% 
  mutate(date_time=str_sub(date_time,start = 7, end=-5)) %>% 
  mutate(date_time=lubridate::ymd_hm(date_time))

hourly_tweet_counts # looking good

sum(hourly_tweet_counts$tweet_count) #115390407 tweets total, matches the monetdb

# quick dirty plot
hourly_tweet_counts %>% 
  group_by(tweet_day=lubridate::floor_date(date_time, "day")) %>%
  summarize(aggregate_amount=sum(tweet_count)) %>% 
  ggplot(aes(x=tweet_day, y=aggregate_amount))+
  geom_line()+
  scale_x_datetime(labels = scales::date_format("%Y-%m-%d"), breaks = scales::date_breaks("1 month")) + theme(axis.text.x = element_text(angle = 90)) 

# problems/improvements with the plot====
 # 1. no visualisation of missing values (previously adressed this manually using add_row (date, NA) but need a more automated and fool-proof approach)
 # 2. faceting would be nice (year, quarter, month)
 # 3. y axis needs sorting
 # 4. add theme et. al.

# adressing 1
date_seq <- seq(ymd('2017-03-20'),ymd('2018-08-27'),by='days') %>% 
  tibble(tweet_day=.)
date_seq # 526 days

hourly_tweet_counts_NAs <- hourly_tweet_counts %>% 
  group_by(tweet_time=lubridate::floor_date(date_time, "day")) %>%
  summarize(tweet_aggregate=sum(tweet_count)) %>% 
  ungroup() %>% 
  mutate(tweet_day=ymd(tweet_time)) %>% 
  right_join(date_seq) %>% 
  mutate(tweet_month=month(tweet_day)) %>% 
  mutate(tweet_year=year(tweet_day))
hourly_tweet_counts_NAs %>% dim() #526 days
hourly_tweet_counts_NAs %>% 
  arrange(desc(tweet_aggregate)) %>% 
  head(20) %>% 
  write.table( file = "../Desktop/temp/muslim_tweets_desc.txt", sep = ",", quote = FALSE, row.names = TRUE)



hourly_tweet_counts_NAs %>% 
  ggplot(aes(x=as.POSIXct( tweet_day), y=tweet_aggregate))+
  geom_line()+
  geom_point()+
  scale_x_datetime(labels = scales::date_format("%Y-%m-%d"), breaks = scales::date_breaks("1 month")) + 
  scale_y_continuous(limits = c(0,1500000),breaks = seq(0,1500000,100000))+
  hrbrthemes::theme_ipsum_rc()+
  theme(axis.text.x = element_text(angle = 90)) +
  labs(title="Number of Tweets Referring to Muslim Identity", 
       subtitle='Data collected from Twitter Streaming API using keywords "muslim" and/or "islam"', 
       caption="Social Data Science Lab\nCardiff University",
       x= "Date",
       y= "Tweet Counts\nAggregated Daily")


ggsave(filename = "Work/twitter_anti_muslim_speech/viz/tweet_counts.png",device = "png",scale = 1,dpi = 320,width = 20, height =9*1.25,units =  "in")

hourly_tweet_counts_NAs %>% 
  ggplot(aes(x=as.POSIXct( tweet_day), y=tweet_aggregate))+
  geom_line()+
  geom_point()+
  scale_x_datetime(labels = scales::date_format("%m"), breaks = scales::date_breaks("1 month")) + 
  theme(axis.text.x = element_text(angle = 90)) +
  scale_y_continuous(limits = c(0,1500000),breaks = seq(0,1500000,100000)) +
  facet_wrap(vars(tweet_year), ncol = 1)
