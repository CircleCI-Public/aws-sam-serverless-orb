#!/bin/bash
ORB_STR_TEMPLATE="$(echo "${ORB_STR_TEMPLATE}" | circleci env subst)"
ORB_STR_ENV_VARS="$(echo "${ORB_STR_ENV_VARS}" | circleci env subst)"

if [ -n "$ORB_STR_TEMPLATE" ]; then
  set -- "$@" -t "$ORB_STR_TEMPLATE"
fi

set -- "$@" -p "$ORB_INT_PORT"

if [ -n "$ORB_STR_ENV_VARS" ]; then
  set -- "$@" -n "$PARAM_ENV_VARS"
fi

if [ -n "$ORB_ENUM_WARM_CONTAINERS" ]; then
  set -- "$@"  --warm-containers "$ORB_ENUM_WARM_CONTAINERS"
fi

if [ "$ORB_BOOL_DEBUG" -eq 1 ]; then
  set -- "$@" --debug
fi

set -x
sam local start-api "$@"
set +x