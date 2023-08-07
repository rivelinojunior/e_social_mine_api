#!/usr/bin/env bash
DB_CONTAINER_NAME='social_mine_db'

docker start $DB_CONTAINER_NAME > /dev/null 2>&1 || \
  (
    docker run --name $DB_CONTAINER_NAME \
               -e POSTGRES_USER=social_mine \
               -e POSTGRES_PASSWORD='S@c1@l_m1nE' \
               -d \
               -p 5432:5432 \
               postgres:alpine
  )
