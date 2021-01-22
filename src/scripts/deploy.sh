set -o noglob
IFS=', ' read -r -a ARRAY_CAPABILITIES <<< "$SAM_PARAM_CAPABILITIES"
echo "${ARRAY_CAPABILITIES[@]}"
set -- "$@" --capabilities "${ARRAY_CAPABILITIES[@]}"
set -- "$@" --stack-name "$SAM_PARAM_STACK_NAME"

TEMP_REGION="\$"$(echo $SAM_PARAM_AWS_REGION)""
set -- "$@" --region "$(eval "echo $TEMP_REGION")"

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

sam deploy "$@"