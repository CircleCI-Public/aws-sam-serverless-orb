#!/bin/bash
set -o noglob
ORB_EVAL_REGION="$(circleci env subst "${ORB_EVAL_REGION}")"
ORB_EVAL_CAPABILITIES="$(circleci env subst "${ORB_EVAL_CAPABILITIES}")"
ORB_EVAL_IMAGE_REPO="$(circleci env subst "${ORB_EVAL_IMAGE_REPO}")"
ORB_EVAL_S3_BUCKET="$(circleci env subst "${ORB_EVAL_S3_BUCKET}")"
ORB_EVAL_TEMPLATE="$(circleci env subst "${ORB_EVAL_TEMPLATE}")"
ORB_EVAL_OVERRIDES="$(circleci env subst "${ORB_EVAL_OVERRIDES}")"
ORB_EVAL_ARGUMENTS="$(circleci env subst "${ORB_EVAL_ARGUMENTS}")"


IFS=', ' read -r -a ARRAY_CAPABILITIES <<< "$ORB_EVAL_CAPABILITIES"
echo "${ARRAY_CAPABILITIES[@]}"
set -- "$@" --capabilities "${ARRAY_CAPABILITIES[@]}"
set -- "$@" --stack-name "$(circleci env subst "{$ORB_EVAL_STACK_NAME}")"


set -- "$@" --region "${ORB_EVAL_REGION}"


if [ -n "$ORB_EVAL_IMAGE_REPO" ]; then
    echo "DEBUG: set_image_repos called" "$(circleci env subst "${ORB_EVAL_IMAGE_REPO}")"| tee -a /tmp/sam.log
    IFS=', ' read -r -a ARRAY_REPOSITORIES <<< "$(circleci env subst "${ORB_EVAL_IMAGE_REPO}")"
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
if [ -n "$ORB_EVAL_S3_BUCKET" ]; then
    # Technically this shouldnt be needed as this shouldnt be possible given the order of execution
    if [ -n "$ORB_EVAL_IMAGE_REPO" ]; then
        echo " parameters.image-repository cannot be set if parameters.s3-bucket is also configured. Remove one of these options."
    fi
    set -- "$@" --s3-bucket "$(circleci env subst "${ORB_EVAL_S3_BUCKET}")"
fi
if [ -n "$ORB_EVAL_TEMPLATE" ]; then
    set -- "$@" --template-file "$(circleci env subst "${ORB_EVAL_TEMPLATE}")"
fi
if [ "$ORB_VAL_DEBUG" = 1 ]; then
    set -- "$@" --debug
fi
if [ "$ORB_VAL_NOFAIL" = 1 ]; then
    set -- "$@" --no-fail-on-empty-changeset
fi
if [ "$ORB_VAL_RESOLVE_S3" = 1 ]; then
    set -- "$@" --resolve-s3
fi
if [ -n "$ORB_EVAL_OVERRIDES" ]; then
    set -- "$@" --parameter-overrides "$(circleci env subst "${ORB_EVAL_OVERRIDES}")"
fi
if [ -z "$ORB_EVAL_ARGUMENTS" ]; then
    set -- "$@" "$ORB_EVAL_ARGUMENTS"
fi

set -x
sam deploy --profile "${ORB_EVAL_PROFILE_NAME}" "$@"
set +x
