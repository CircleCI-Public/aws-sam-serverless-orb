
if [ -n "$SAM_PARAM_S3_BUCKET" ] || [ -n "$SAM_PARAM_IMAGE_REPO" ]; then
    set -o noglob
    set -- "$@" --template-file "$(eval "echo $SAM_PARAM_TEMPLATE")"
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
        if [ -n "$SAM_PARAM_S3_BUCKET" ]; then
            echo " parameters.s3-bucket cannot be set if parameters.image-repository is also configured. Remove one of these options."
        fi
        set -- "$@" --image-repository "$SAM_PARAM_IMAGE_REPO"
    fi


    if [ -n "$SAM_PARAM_OUTPUT_TEMPLATE" ]; then
        set -- "$@" --output-template-file "$(eval "echo $SAM_PARAM_OUTPUT_TEMPLATE")"
    fi
    if [ "$SAM_PARAM_DEBUG" = 1 ]; then
        set -- "$@" --debug
    fi

    sam package "$@"
else
    echo "No S3 Bucket or Image repo provided."
    echo "Skipping packaging step"
fi