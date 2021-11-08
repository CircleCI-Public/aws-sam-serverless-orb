set -o noglob
IFS=', ' read -r -a ARRAY_CAPABILITIES <<< "$SAM_PARAM_CAPABILITIES"
echo "${ARRAY_CAPABILITIES[@]}"
set -- "$@" --capabilities "${ARRAY_CAPABILITIES[@]}"
set -- "$@" --stack-name "$SAM_PARAM_STACK_NAME"

TEMP_REGION="\$"$(echo $SAM_PARAM_AWS_REGION)""
set -- "$@" --region "$(eval "echo $TEMP_REGION")"


if [ -n "$SAM_PARAM_IMAGE_REPO" ]; then
    if [ -n "$SAM_PARAM_S3_BUCKET" ]; then
        echo " parameters.s3-bucket cannot be set if parameters.image-repository is also configured. Remove one of these options."
        exit 1
    fi
    echo "DEBUG: set_image_repos called" "$(eval echo "$SAM_PARAM_IMAGE_REPO")"
    IFS=', ' read -r -a ARRAY_REPOSITORIES <<< "$(eval echo "$SAM_PARAM_IMAGE_REPO")"
    REPOARRYLEN=${#ARRAY_REPOSITORIES[@]}
    if [ "$REPOARRYLEN" = 1 ]; then
        echo "DEBUG: Single image repo"
        echo "DEBUG: ${ARRAY_REPOSITORIES[0]}"
        set -- "$@" --image-repository "$(eval echo "${ARRAY_REPOSITORIES[0]}")"
    else
        for image in "${!ARRAY_REPOSITORIES[@]}"; do
            echo "DEBUG: Multi image repo"
            echo "Images: ${#ARRAY_REPOSITORIES[@]}"
            echo "DEBUG: ${ARRAY_REPOSITORIES[image]}"
            set -- "$@" --image-repositories "$(eval echo "${ARRAY_REPOSITORIES[image]}")"
        done
    fi
fi
if [ -n "$SAM_PARAM_S3_BUCKET" ]; then
    # Technically this shouldnt be needed as this shouldnt be possible given the order of execution
    if [ -n "$SAM_PARAM_IMAGE_REPO" ]; then
        echo " parameters.image-repository cannot be set if parameters.s3-bucket is also configured. Remove one of these options."
    fi
    set -- "$@" --s3-bucket "$SAM_PARAM_S3_BUCKET"
fi
if [ -n "$SAM_PARAM_PROFILE_NAME" ]; then
    set -- "$@" --profile "$SAM_PARAM_PROFILE_NAME"
fi
if [ -n "$SAM_PARAM_TEMPLATE" ]; then
    set -- "$@" --template-file "$(eval "echo $SAM_PARAM_TEMPLATE")"
fi
if [ -n "$SAM_PARAM_CONFIG_TOML" ]; then
    set -- "$@" --config-file "$(eval "echo $SAM_PARAM_CONFIG_TOML")"
fi
if [ "$SAM_PARAM_DEBUG" = 1 ]; then
    set -- "$@" --debug
fi
if [ "$SAM_PARAM_PARAMETER_NOFAIL" = 1 ]; then
    set -- "$@" --no-fail-on-empty-changeset
fi
if [ -n "$SAM_PARAM_PARAMETER_OVERRIDES" ]; then
    set -- "$@" --parameter-overrides "$SAM_PARAM_PARAMETER_OVERRIDES"
fi
sam deploy "$@"