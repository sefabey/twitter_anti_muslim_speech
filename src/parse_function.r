library(tidyverse)
parse_function <- function (x){
  
  if (str_detect(x, "jsonl")) {
  gc()
  json <- ndjson::stream_in(x) %>% 
    filter(lang=="en") %>% 
    distinct(id_str,.keep_all = T) %>%
    mutate(  
      quoted_status.coordinates.coordinates.0= ifelse(is.null(.$quoted_status.coordinates.coordinates.0), NA, .$quoted_status.coordinates.coordinates.0),
      quoted_status.coordinates.coordinates.1= ifelse(is.null(.$quoted_status.coordinates.coordinates.1), NA, .$quoted_status.coordinates.coordinates.1),
      retweeted_status.coordinates.coordinates.0= ifelse(is.null(.$retweeted_status.coordinates.coordinates.0), NA, .$retweeted_status.coordinates.coordinates.0),
      retweeted_status.coordinates.coordinates.1= ifelse(is.null(.$retweeted_status.coordinates.coordinates.1), NA, .$retweeted_status.coordinates.coordinates.1),
      coordinates.coordinates.0= ifelse(is.null(.$coordinates.coordinates.0), NA, .$coordinates.coordinates.0),
      coordinates.coordinates.1= ifelse(is.null(.$coordinates.coordinates.1), NA, .$coordinates.coordinates.1),
      coordinates.type= ifelse(is.null(.$coordinates.type), NA, .$coordinates.type),
      withheld_in_countries.0= ifelse(is.null(.$withheld_in_countries.0), NA, .$withheld_in_countries.0),
      quoted_status.extended_tweet.full_text= ifelse(is.null(.$quoted_status.extended_tweet.full_text), NA, .$quoted_status.extended_tweet.full_text),
      retweeted_status.extended_tweet.full_text= ifelse(is.null(.$retweeted_status.extended_tweet.full_text), NA, .$retweeted_status.extended_tweet.full_text),
      extended_tweet.full_text= ifelse(is.null(.$extended_tweet.full_text), NA, .$extended_tweet.full_text)
      ) %>%
    select(text,
           created_at,
           id,
           id_str,
           lang,
           possibly_sensitive,
           source,
           timestamp_ms,
           coord_longitude=coordinates.coordinates.0,
           coord_latitude=coordinates.coordinates.1,
           coordinates.type,
           place.name,
           place.country,
           place.country_code,
           entities.urls.0.expanded_url,
           withheld_in_countries.0,
           user.created_at,
           user.description,
           user.followers_count,
           user.friends_count,
           user.id,
           user.id_str,
           user.location,
           user.name,
           user.protected,
           user.screen_name,
           user.statuses_count,
           user.verified,
           user.location,
           user.time_zone,
           is_quote_status,
           quoted_status.created_at,
           quoted_status.id,
           quoted_status.id_str,
           quoted_status.text,
           quoted_status.lang,
           quoted_status.possibly_sensitive,
           quoted_status.coord_longitude= quoted_status.coordinates.coordinates.0,
           quoted_status.coord_latitude= quoted_status.coordinates.coordinates.1,
           quoted_status.place.name,
           quoted_status.place.country,
           quoted_status.place.country_code,
           quoted_status.entities.urls.0.expanded_url,
           quoted_status.user.created_at,
           quoted_status.user.description,
           quoted_status.user.friends_count,
           quoted_status.user.followers_count,
           quoted_status.user.id,
           quoted_status.user.id_str,
           quoted_status.user.screen_name,
           quoted_status.user.name,
           quoted_status.user.statuses_count,
           quoted_status.user.verified,
           quoted_status.user.protected,
           quoted_status.user.location,
           quoted_status.user.time_zone,
           retweeted_status.created_at,
           retweeted_status.id,
           retweeted_status.id_str,
           retweeted_status.text,
           retweeted_status.lang,
           retweeted_status.possibly_sensitive,
           retweeted_status.coord_longitude=retweeted_status.coordinates.coordinates.0,
           retweeted_status.coord_latitude=retweeted_status.coordinates.coordinates.1,
           retweeted_status.place.name,
           retweeted_status.place.country,
           retweeted_status.place.country_code,
           retweeted_status.entities.urls.0.expanded_url,
           retweeted_status.user.created_at,
           retweeted_status.user.description,
           retweeted_status.user.followers_count,
           retweeted_status.user.friends_count,
           retweeted_status.user.id,
           retweeted_status.user.id_str,
           retweeted_status.user.screen_name,
           retweeted_status.user.name,
           retweeted_status.user.statuses_count,
           retweeted_status.user.verified,
           retweeted_status.user.location,
           retweeted_status.user.protected,
           retweeted_status.user.time_zone,
           in_reply_to_screen_name,
           in_reply_to_status_id,
           in_reply_to_status_id_str,
           in_reply_to_user_id,
           in_reply_to_user_id_str,
           quoted_status.extended_tweet.full_text,
           retweeted_status.extended_tweet.full_text,
           extended_tweet.full_text) %>% 
    mutate(text_real= case_when(
      !is.na(extended_tweet.full_text) ~ extended_tweet.full_text ,
      !is.na(retweeted_status.extended_tweet.full_text) ~ retweeted_status.extended_tweet.full_text,
      #!is.na(quoted_status.extended_tweet.full_text) ~ quoted_status.extended_tweet.full_text,
      TRUE ~ text)) %>% 
    select(text_real, id_str, everything()) %>% 
    filter(str_detect(string = text_real, pattern = regex('muslim|islam',ignore_case = T)))
  write_csv(json, path = paste0(str_sub(x,end = -7), ".csv"))
  gc()
  }else {
    
    print(paste0("Not a jsonl file this ", x))
  }
} 


