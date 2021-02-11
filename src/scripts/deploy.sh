set -o noglob
set_image_repos () {
    set -o noglob
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
}
IFS=', ' read -r -a ARRAY_CAPABILITIES <<< "$SAM_PARAM_CAPABILITIES"
echo "${ARRAY_CAPABILITIES[@]}"
set -- "$@" --capabilities "${ARRAY_CAPABILITIES[@]}"
set -- "$@" --stack-name "$SAM_PARAM_STACK_NAME"

TEMP_REGION="\$"$(echo $SAM_PARAM_AWS_REGION)""
set -- "$@" --region "$(eval "echo $TEMP_REGION")"


if [ -n "$SAM_PARAM_IMAGE_REPO" ]; then
    set_image_repos
fi
if [ -n "$SAM_PARAM_PROFILE_NAME" ]; then
    set -- "$@" --profile "$SAM_PARAM_PROFILE_NAME"
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
if [ -n "$SAM_PARAM_PARAMETER_OVERRIDES" ]; then
    set -- "$@" --parameter-overrides "$SAM_PARAM_PARAMETER_OVERRIDES"
fi
echo "DEBUG: settings" "$@"
sam deploy "$@"