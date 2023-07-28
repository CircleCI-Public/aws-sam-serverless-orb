#!/bin/bash
set -o noglob
ORB_STR_REGION="$(echo "${ORB_STR_REGION}" | circleci env subst)"
ORB_STR_TEMPLATE="$(echo "${ORB_STR_TEMPLATE}" | circleci env subst)"
ORB_EVAL_BUILD_DIR="$(eval echo "${ORB_EVAL_BUILD_DIR}" | circleci env subst)"
ORB_EVAL_BASE_DIR="$(eval echo "${ORB_EVAL_BASE_DIR}" | circleci env subst)"

set -- "$@" --template-file "${ORB_STR_TEMPLATE}"

set -- "$@" --region "${ORB_STR_REGION}"

if [ -n "$ORB_EVAL_BUILD_DIR" ]; then
  set -- "$@" --build-dir "${ORB_EVAL_BUILD_DIR}"
fi
if [ -n "$ORB_EVAL_BASE_DIR" ]; then
  set -- "$@" --base-dir "${ORB_EVAL_BASE_DIR}"
fi
if [ "$ORB_BOOL_USE_CONTAINER" -eq 1 ]; then
  set -- "$@" --use-container
fi
if [ "$ORB_BOOL_DEBUG" -eq 1 ]; then
  set -- "$@" --debug
fi
if [ -n "$SAM_PARAM_PARAMETER_OVERRIDES" ]; then
    set -- "$@" --parameter-overrides "$(eval "echo $SAM_PARAM_PARAMETER_OVERRIDES")"
fi
if [ -n "$SAM_PARAM_ADDITIONAL_ARGS" ]; then
    set -- "$@" "$SAM_PARAM_ADDITIONAL_ARGS"
fi

set -x
sam build --profile "${ORB_STR_PROFILE_NAME}" "$@"
set +x
