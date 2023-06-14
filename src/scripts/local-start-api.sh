#!/bin/bash
ORB_EVAL_TEMPLATE="$(circleci env subst "${ORB_EVAL_TEMPLATE}")"
ORB_EVAL_ENV_VARS="$(circleci env subst "${ORB_EVAL_ENV_VARS}")"
if [ -n "$ORB_EVAL_TEMPLATE" ]; then
  set -- "$@" -t "$ORB_EVAL_TEMPLATE"
fi

set -- "$@" -p "$ORB_VAL_PORT"

if [ -n "$ORB_EVAL_ENV_VARS" ]; then
  set -- "$@" -n "$PARAM_ENV_VARS"
fi

if [ "$ORB_VAL_DEBUG" = 1 ]; then
  set -- "$@" --debug
fi

set -x
sam local start-api "$@"
set +x