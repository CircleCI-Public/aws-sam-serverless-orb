#!/bin/bash
ORB_STR_ENDPOINT="$(circleci env subst "${ORB_STR_ENDPOINT}")"
dockerize -wait "http://127.0.0.1:3000/${ORB_STR_ENDPOINT}" -timeout "${ORB_INT_TIMEOUT}m"