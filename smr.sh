#! /usr/bin/env bash
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P)
PROJECT_HANDLE=$(cd ${ROOT_DIR};echo ${PWD##*/});

smr () {
  #display help menu
  if [[ $1 == "--help" ]]; then
      smr_give_me_help
      exit
  fi

  if [[ $1 == "-setup" ]]; then
    #create image from directory
    docker build -t server:latest $ROOT_DIR/apache-php7.4/

    #check if docker container exists and delete if exists
    if [[ ! "$(docker ps -aq -f name=send-million-requests)" ]]; then
      run_container
      exit
    fi

    if [[ "$(docker ps -aq -f status=exited)" ]]; then
        docker stop send-million-requests
    fi
      docker rm send-million-requests
      run_container
  fi

  #start console inside container
  if [[ $1 == "-console" ]]; then
    docker exec -it send-million-requests /bin/bash
  fi
}

run_container() {
#   docker run -d -p 8080:80 --name send-million-requests \
#   --mount type=bind,source=$ROOT_DIR/app/data.csv,destination=/var/www/html/data.csv \
#   --mount type=bind,source=$ROOT_DIR/app/index.php,destination=/var/www/html/index.php \
#    server:latest
   docker run -d -p 8080:80 --name send-million-requests \
   --mount type=bind,source=$ROOT_DIR/app/,destination=/var/www/html/ \
    server:latest
}

smr_give_me_help () {
  printf '\n'
  cat $ROOT_DIR/doc/help.md
  printf '\n'
}
smr $@
