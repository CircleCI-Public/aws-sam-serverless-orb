#!/bin/bash
set -o noglob
ORB_STR_REGION="$(echo "${ORB_STR_REGION}" | circleci env subst)"
ORB_STR_TEMPLATE="$(echo "${ORB_STR_TEMPLATE}" | circleci env subst)"
ORB_STR_BUILD_PARAMETER_OVERRIDES="$(echo "${ORB_STR_BUILD_PARAMETER_OVERRIDES}" | circleci env subst)"
ORB_STR_BUILD_ARGUMENTS="$(echo "${ORB_STR_BUILD_ARGUMENTS}" | circleci env subst)"
ORB_STR_BUILD_CONTAINER_VARS="$(echo "${ORB_STR_BUILD_CONTAINER_VARS}" | circleci env subst)"
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
if [ "$ORB_BOOL_USE_CONTAINER" -eq 0 ] && [ -n "$ORB_STR_BUILD_CONTAINER_VARS" ]; then
  echo "Error - use_container parameter set to false. Set to true to use build_container_vars"
  exit 1;
elif [ "$ORB_BOOL_USE_CONTAINER" -eq 1 ]; then
  set -- "$@" --use-container
    if [ -n "$ORB_STR_BUILD_CONTAINER_VARS" ]; then
      IFS="," read -ra container_vars <<< "${ORB_STR_BUILD_CONTAINER_VARS}"
      for var in "${container_vars[@]}"; do
        set -- "$@" --container-env-var "${var}"
      done
    fi
fi
if [ "$ORB_BOOL_DEBUG" -eq 1 ]; then
  set -- "$@" --debug
fi
if [ -n "$ORB_STR_BUILD_PARAMETER_OVERRIDES" ]; then
    set -- "$@" --parameter-overrides "${ORB_STR_BUILD_PARAMETER_OVERRIDES}"
fi
if [ -n "$ORB_STR_BUILD_ARGUMENTS" ]; then
    # shellcheck disable=SC2086
    set -- "$@" ${ORB_STR_BUILD_ARGUMENTS}
fi

set -x
sam build --profile "${ORB_STR_PROFILE_NAME}" "$@"
set +x
