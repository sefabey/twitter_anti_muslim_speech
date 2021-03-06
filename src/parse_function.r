library(tidyverse)
parse_function <- function (x){
  
  if (str_detect(x, "jsonl")) {
  gc()
  json <- ndjson::stream_in(x) %>% 
    filter(lang=="en") %>% 
    distinct(id_str,.keep_all = T) %>%
    mutate(
      quoted_status.coordinates.coordinates.0 = if ("quoted_status.coordinates.coordinates.0" %in% names(.)){return(quoted_status.coordinates.coordinates.0)}else{return(NA)},
      quoted_status.coordinates.coordinates.1= if ("quoted_status.coordinates.coordinates.1" %in% names(.)){return(quoted_status.coordinates.coordinates.1)}else{return(NA)},
      retweeted_status.coordinates.coordinates.0= if ("retweeted_status.coordinates.coordinates.0" %in% names(.)){return(retweeted_status.coordinates.coordinates.0)}else{return(NA)},
      retweeted_status.coordinates.coordinates.1= if ("retweeted_status.coordinates.coordinates.1" %in% names(.)){return(retweeted_status.coordinates.coordinates.1)}else{return(NA)},
      coordinates.coordinates.0= if ("coordinates.coordinates.0" %in% names(.)){return(coordinates.coordinates.0)}else{return(NA)},
      coordinates.coordinates.1= if ("coordinates.coordinates.1" %in% names(.)){return(coordinates.coordinates.1)}else{return(NA)},
      coordinates.type= if ("coordinates.type" %in% names(.)){return(coordinates.type)}else{return(NA)},
      withheld_in_countries.0= if ("withheld_in_countries.0" %in% names(.)){return(withheld_in_countries.0)}else{return(NA)},
      quoted_status.extended_tweet.full_text= if ("quoted_status.extended_tweet.full_text" %in% names(.)){return(quoted_status.extended_tweet.full_text)}else{return(NA)},
      retweeted_status.extended_tweet.full_text= if ("retweeted_status.extended_tweet.full_text" %in% names(.)){return(retweeted_status.extended_tweet.full_text)}else{return(NA)},
      extended_tweet.full_text= if ("extended_tweet.full_text" %in% names(.)){return(extended_tweet.full_text)}else{return(NA)},
      place.name= if ("place.name" %in% names(.)){return(place.name)}else{return(NA)},
      quoted_status.place.name= if ("quoted_status.place.name" %in% names(.)){return(quoted_status.place.name)}else{return(NA)},
      place.country= if ("place.country" %in% names(.)){return(place.country)}else{return(NA)},
      quoted_status.place.country= if ("quoted_status.place.country" %in% names(.)){return(quoted_status.place.country)}else{return(NA)},
      quoted_status.place.country_code= if ("quoted_status.place.country_code" %in% names(.)){return(quoted_status.place.country_code)}else{return(NA)},
      place.country_code= if ("place.country_code" %in% names(.)){return(place.country_code)}else{return(NA)},
      retweeted_status.place.name= if ("retweeted_status.place.name" %in% names(.)){return(retweeted_status.place.name)}else{return(NA)},
      retweeted_status.place.country= if ("retweeted_status.place.country" %in% names(.)){return(retweeted_status.place.country)}else{return(NA)},
      retweeted_status.place.country_code= if ("retweeted_status.place.country_code" %in% names(.)){return(retweeted_status.place.country_code)}else{return(NA)},
      quoted_status.entities.urls.0.expanded_url= if ("quoted_status.entities.urls.0.expanded_url" %in% names(.)){return(quoted_status.entities.urls.0.expanded_url)}else{return(NA)}
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
    select(text_real, id_str, everything())
    # filter(str_detect(string = text_real, pattern = regex('muslim|islam',ignore_case = T)))
  write_csv(json, path = paste0(str_sub(x,end = -7), ".csv"))
  gc()
  }else {
    
    print(paste0("Not a jsonl file this ", x))
  }
} 


