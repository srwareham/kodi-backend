#!/usr/bin/env bash

# Backup the mysql database which holds kodi's audio and video libraries

# Assumes the relevant volume was built / started with docker-compose inside the kodibackend folder and is accordingly named kodibackend_kodi-mysql-data
docker run --rm -it -v kodibackend_kodi-mysql-data:/var/lib/msql -v $(pwd):/backup ubuntu bash -c "tar czvf /backup/msql.tar.gz /var/lib/msql && chown $(id -u):$(id -g) /backup/msql.tar.gz"

# If you would like to do this interactively, would need to pass the userid and groupid as environment variables
# i.e., docker run -e userid=$(id -u) -e groupid=$(id -g)