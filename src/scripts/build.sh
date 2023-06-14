#!/bin/bash
set -o noglob
ORB_STR_REGION="$(circleci env subst "${ORB_STR_REGION}")"
ORB_STR_TEMPLATE="$(circleci env subst "${ORB_STR_TEMPLATE}")"
ORB_EVAL_BUILD_DIR="$(eval echo "${ORB_EVAL_BUILD_DIR}")"
ORB_EVAL_BASE_DIR="$(eval echo "${ORB_EVAL_BASE_DIR}")"

set -- "$@" --template-file "${ORB_STR_TEMPLATE}"

set -- "$@" --region "${ORB_STR_REGION}"

if [ -n "$ORB_EVAL_BUILD_DIR" ]; then
  set -- "$@" --build-dir "${ORB_EVAL_BUILD_DIR}"
fi
if [ -n "$ORB_EVAL_BASE_DIR" ]; then
  set -- "$@" --base-dir "${ORB_EVAL_BASE_DIR}"
fi
if [ "$ORB_BOOL_USE_CONTAINER" = 1 ]; then
  set -- "$@" --use-container
fi
if [ "$ORB_BOOL_DEBUG" = 1 ]; then
  set -- "$@" --debug
fi

set -x
sam build --profile "${ORB_STR_PROFILE_NAME}" "$@"
set +x
