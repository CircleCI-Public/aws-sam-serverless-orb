#!/bin/bash
set -o noglob
IFS=', ' read -r -a ARRAY_CAPABILITIES <<< "$SAM_PARAM_CAPABILITIES"
echo "${ARRAY_CAPABILITIES[@]}"
set -- "$@" --capabilities "${ARRAY_CAPABILITIES[@]}"
set -- "$@" --stack-name "$(eval echo "$SAM_PARAM_STACK_NAME")"

set -- "$@" --region "${!SAM_PARAM_AWS_REGION}"


if [ -n "$SAM_PARAM_IMAGE_REPO" ]; then
    if [ -n "$SAM_PARAM_S3_BUCKET" ]; then
        echo " parameters.s3-bucket cannot be set if parameters.image-repository is also configured. Remove one of these options."
        exit 1
    fi
    echo "DEBUG: set_image_repos called" "$(eval echo "$SAM_PARAM_IMAGE_REPO")" | tee -a /tmp/sam.log
    IFS=', ' read -r -a ARRAY_REPOSITORIES <<< "$(eval echo "$SAM_PARAM_IMAGE_REPO")"
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
if [ -n "$SAM_PARAM_S3_BUCKET" ]; then
    # Technically this shouldnt be needed as this shouldnt be possible given the order of execution
    if [ -n "$SAM_PARAM_IMAGE_REPO" ]; then
        echo " parameters.image-repository cannot be set if parameters.s3-bucket is also configured. Remove one of these options."
    fi
    set -- "$@" --s3-bucket "$(eval "echo $SAM_PARAM_S3_BUCKET")"
fi
if [ -n "$SAM_PARAM_PROFILE_NAME" ]; then
    set -- "$@" --profile "$(eval echo "$SAM_PARAM_PROFILE_NAME")"
fi
if [ -n "$SAM_PARAM_TEMPLATE" ]; then
    set -- "$@" --template-file "$(eval "echo $SAM_PARAM_TEMPLATE")"
fi
if [ "$SAM_PARAM_DEBUG" = 1 ]; then
    set -- "$@" --debug
fi
if [ "$SAM_PARAM_PARAMETER_NOFAIL" = 1 ]; then
    set -- "$@" --no-fail-on-empty-changeset
fi
if [ "$SAM_PARAM_RESOLVE_S3" = 1 ]; then
    set -- "$@" --resolve-s3
fi
if [ -n "$SAM_PARAM_PARAMETER_OVERRIDES" ]; then
    set -- "$@" --parameter-overrides "$(eval "echo $SAM_PARAM_PARAMETER_OVERRIDES")"
fi

set -x
sam deploy "$@"
set +x
