#!/bin/bash
ORB_STR_DOCKERIZE_VERSION="$(echo "${ORB_STR_DOCKERIZE_VERSION}" | circleci env subst)"

wget "https://github.com/jwilder/dockerize/releases/download/v${ORB_STR_DOCKERIZE_VERSION}/dockerize-linux-amd64-v${ORB_STR_DOCKERIZE_VERSION}.tar.gz" && \
  sudo tar -C /usr/local/bin -xzvf "dockerize-linux-amd64-v${ORB_STR_DOCKERIZE_VERSION}.tar.gz" && \
  rm "dockerize-linux-amd64-v${ORB_STR_DOCKERIZE_VERSION}.tar.gz"