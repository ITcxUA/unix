#!/bin/bash


docker run \
  -v data:/airsonic/data \
  -v music:/airsonic/music \
  -v playlists:/airsonic/playlists \
  -v podcasts:/airsonic/podcasts \
  -p 4040:4040 \
  -d \
  airsonic/airsonic

DatabaseConfigType=embed
DatabaseConfigEmbedDriver=com.mysql.jdbc.Driver
DatabaseConfigEmbedUrl=jdbc:mysql://localhost:3306/airsonic
DatabaseConfigEmbedUsername=root
DatabaseConfigEmbedPassword=yourpasswordhere

## ********************************************************
docker run --name mariadb \
	-e MYSQL_DATABASE=airsonic \
	-e MYSQL_ROOT_PASSWORD=yourpasswordhere \
	-p 3306:3306 \
	-d mariadb:10.4 \
	--character-set-server=utf8 \
	--collation-server=utf8_general_ci


exit
