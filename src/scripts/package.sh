set -o noglob
set_image_repos() {
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
echo "DEBUG: $(eval echo "$SAM_PARAM_IMAGE_REPO")"
if [ -n "$SAM_PARAM_S3_BUCKET" ] || [ -n "$SAM_PARAM_IMAGE_REPO" ]; then
    set -- "$@" --profile "$SAM_PARAM_PROFILE"

    TEMP_REGION="\$"$(echo $SAM_PARAM_AWS_REGION)""
    set -- "$@" --region "$(eval "echo $TEMP_REGION")"

    if [ -n "$SAM_PARAM_S3_BUCKET" ]; then
        if [ -n "$SAM_PARAM_IMAGE_REPO" ]; then
            echo " parameters.image-repository cannot be set if parameters.s3-bucket is also configured. Remove one of these options."
        fi
        set -- "$@" --s3-bucket "$SAM_PARAM_S3_BUCKET"
    fi
    if [ -n "$SAM_PARAM_IMAGE_REPO" ]; then
        echo "DEBUG: image repo param selected"
        if [ -n "$SAM_PARAM_S3_BUCKET" ]; then
            echo " parameters.s3-bucket cannot be set if parameters.image-repository is also configured. Remove one of these options."
            exit 1
        fi
        set_image_repos
    else
        set -- "$@" --template-file "$(eval "echo $SAM_PARAM_TEMPLATE")"
    fi

    if [ "$SAM_PARAM_DEBUG" = 1 ]; then
        set -- "$@" --debug
    fi

    sam package "$@"
else
    echo "No S3 Bucket or Image repo provided."
    echo "Skipping packaging step"
fi