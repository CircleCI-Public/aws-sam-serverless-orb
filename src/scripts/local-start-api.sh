#!/bin/bash

if [ -n "$PARAM_TEMPLATE" ]; then
  set -- "$@" -t "$PARAM_TEMPLATE"
fi

set -- "$@" -p "$PARAM_PORT"

if [ -n "$PARAM_ENV_VARS" ]; then
  set -- "$@" -n "$PARAM_ENV_VARS"
fi

if [ "$PARAM_DEBUG" = 1 ]; then
  set -- "$@" --debug
fi

set -x
sam local start-api "$@"
set +x