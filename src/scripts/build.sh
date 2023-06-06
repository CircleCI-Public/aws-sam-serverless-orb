#!/bin/bash
set -o noglob
ORB_EVAL_REGION="$(circleci env subst "${ORB_EVAL_REGION}")"

set -- "$@" --template-file "$(circleci env subst "${ORB_EVAL_TEMPLATE}")"

set -- "$@" --region "${ORB_EVAL_REGION}"

if [ -n "$ORB_EVAL_BUILD_DIR" ]; then
  set -- "$@" --build-dir "$(circleci env subst "${ORB_EVAL_BUILD_DIR}")"
fi
if [ -n "$ORB_EVAL_BASE_DIR" ]; then
  set -- "$@" --base-dir "$(circleci env subst "${ORB_EVAL_BASE_DIR}")"
fi
if [ "$ORB_VAL_USE_CONTAINER" = 1 ]; then
  set -- "$@" --use-container
fi
if [ "$ORB_VAL_DEBUG" = 1 ]; then
  set -- "$@" --debug
fi

set -x
sam build --profile "${ORB_EVAL_PROFILE_NAME}" "$@"
set +x
