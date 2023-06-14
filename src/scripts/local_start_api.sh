#!/bin/bash
ORB_STR_TEMPLATE="$(circleci env subst "${ORB_STR_TEMPLATE}")"
ORB_STR_ENV_VARS="$(circleci env subst "${ORB_STR_ENV_VARS}")"
if [ -n "$ORB_STR_TEMPLATE" ]; then
  set -- "$@" -t "$ORB_STR_TEMPLATE"
fi

set -- "$@" -p "$ORB_INT_PORT"

if [ -n "$ORB_STR_ENV_VARS" ]; then
  set -- "$@" -n "$PARAM_ENV_VARS"
fi

if [ "$ORB_BOOL_DEBUG" = 1 ]; then
  set -- "$@" --debug
fi

set -x
sam local start-api "$@"
set +x