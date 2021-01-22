echo $SAM_PARAM_TEMPLATE
set -o noglob
set -- "$@" --capabilities "$SAM_PARAM_CAPABILITIES"
set -- "$@" --stack-name "$SAM_PARAM_STACK_NAME"
set -- "$@" --region "$SAM_PARAM_AWS_REGION"

if [ -n "$SAM_PARAM_PROFILE_NAME" ]; then
    set -- "$@" --profile "$SAM_PARAM_PROFILE_NAME"
fi
if [ -n "$SAM_PARAM_TEMPLATE" ]; then
    set -- "$@" --template-file $(eval "echo $SAM_PARAM_TEMPLATE")
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