#!/bin/bash
ORB_EVAL_ENDPOINT="$(circleci env subst "${ORB_EVAL_ENDPOINT}")"
dockerize -wait "http://127.0.0.1:3000/${ORB_EVAL_ENDPOINT}" -timeout "${ORB_VAL_TIMEOUT}m"