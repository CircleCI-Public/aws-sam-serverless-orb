#!/bin/bash
set -o noglob
ORB_STR_CAPABILITIES="$(echo "${ORB_STR_CAPABILITIES}" | circleci env subst)"
ORB_STR_IMAGE_REPO="$(echo "${ORB_STR_IMAGE_REPO}" | circleci env subst)"
ORB_STR_S3_BUCKET="$(echo "${ORB_STR_S3_BUCKET}" | circleci env subst)"
ORB_STR_TEMPLATE="$(echo "${ORB_STR_TEMPLATE}" | circleci env subst)"
ORB_STR_OVERRIDES="$(echo "${ORB_STR_OVERRIDES}" | circleci env subst)"
ORB_STR_ARGUMENTS="$(echo "${ORB_STR_ARGUMENTS}" | circleci env subst)"
ORB_STR_REGION="$(echo "${ORB_STR_REGION}" | circleci env subst)"
ORB_STR_STACK_NAME="$(echo "${ORB_STR_STACK_NAME}" | circleci env subst)"
ORB_STR_S3_BUCKET="$(echo "${ORB_STR_S3_BUCKET}" | circleci env subst)"
ORB_STR_OVERRIDES="$(echo "${ORB_STR_OVERRIDES}" | circleci env subst)"


IFS=', ' read -r -a ARRAY_CAPABILITIES <<< "$ORB_STR_CAPABILITIES"
echo "${ARRAY_CAPABILITIES[@]}"
set -- "$@" --capabilities "${ARRAY_CAPABILITIES[@]}"
set -- "$@" --stack-name "${ORB_STR_STACK_NAME}"
set -- "$@" --region "${ORB_STR_REGION}"


if [ -n "$ORB_STR_IMAGE_REPO" ]; then
    echo "DEBUG: set_image_repos called" "${ORB_STR_IMAGE_REPO}"| tee -a /tmp/sam.log
    IFS=', ' read -r -a ARRAY_REPOSITORIES <<< "${ORB_STR_IMAGE_REPO}"
    REPOARRYLEN=${#ARRAY_REPOSITORIES[@]}
    if [ "$REPOARRYLEN" = 1 ]; then
        echo "DEBUG: Single image repo named ${ARRAY_REPOSITORIES[0]}" | tee -a /tmp/sam.log
        set -- "$@" --image-repository "${ARRAY_REPOSITORIES[0]}"
    else
        for image in "${!ARRAY_REPOSITORIES[@]}"; do
            echo "DEBUG: Multi image repo" "${ARRAY_REPOSITORIES[$image]}" | tee -a /tmp/sam.log
            echo "Images: ${#ARRAY_REPOSITORIES[@]}" | tee -a /tmp/sam.log
            echo "DEBUG: ${ARRAY_REPOSITORIES[image]}" | tee -a /tmp/sam.log
            set -- "$@" --image-repositories "${!ARRAY_REPOSITORIES[0]}"
        done
    fi
fi
if [ -n "$ORB_STR_S3_BUCKET" ]; then
    # Technically this shouldnt be needed as this shouldnt be possible given the order of execution
    if [ -n "$ORB_STR_IMAGE_REPO" ]; then
        echo " parameters.image-repository cannot be set if parameters.s3-bucket is also configured. Remove one of these options."
    fi
    set -- "$@" --s3-bucket "${ORB_STR_S3_BUCKET}"
fi
if [ -n "$ORB_STR_TEMPLATE" ]; then
    set -- "$@" --template-file "${ORB_STR_TEMPLATE}"
fi
if [ "$ORB_BOOL_DEBUG" -eq 1 ]; then
    set -- "$@" --debug
fi
if [ "$ORB_BOOL_NOFAIL" -eq 1 ]; then
    set -- "$@" --no-fail-on-empty-changeset
fi
if [ "$ORB_BOOL_RESOLVE_S3" -eq 1 ]; then
    set -- "$@" --resolve-s3
fi
if [ -n "$ORB_STR_OVERRIDES" ]; then
    set -- "$@" --parameter-overrides "${ORB_STR_OVERRIDES}"
fi
if [ -n "$ORB_STR_ARGUMENTS" ]; then
    set -- "$@" "$ORB_STR_ARGUMENTS"
fi
set -x
sam deploy --profile "${ORB_STR_PROFILE_NAME}" "$@"
set +x
