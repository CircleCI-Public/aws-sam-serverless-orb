echo "DEBUG: $(echo "$SAM_PARAM_IMAGE_REPO")"
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
        echo "DEBUG: image repo param selected"
        if [ -n "$SAM_PARAM_S3_BUCKET" ]; then
            echo " parameters.s3-bucket cannot be set if parameters.image-repository is also configured. Remove one of these options."
        fi
        IFS=', ' read -r -a ARRAY_REPOSITORIES <<< "$SAM_PARAM_IMAGE_REPO"
        REPOARRYLEN=${#ARRAY_REPOSITORIES[@]}
        echo "DEBUG: $REPOARRYLEN"
        if [ "$REPOARRYLEN" = 1 ]; then
            echo "DEBUG: ${ARRAY_REPOSITORIES[0]}"
            set -- "$@" --image-repository "$(echo "${ARRAY_REPOSITORIES[0]}")"
        else
            for image in "${!ARRAY_REPOSITORIES[@]}"; do
                echo "DEBUG: ${ARRAY_REPOSITORIES[image]}"
                set -- "$@" --image-repositories "$(echo "${ARRAY_REPOSITORIES[image]}")"
            done
        fi
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