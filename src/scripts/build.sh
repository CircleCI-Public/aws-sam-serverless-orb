set -o noglob

set -- "$@" --profile "$(eval "echo $SAM_PARAM_PROFILE")"

set -- "$@" --template-file "$(eval "echo $SAM_PARAM_TEMPLATE")"

TEMP_REGION="\$"$(echo $SAM_PARAM_AWS_REGION)""
set -- "$@" --region "$(eval "echo $TEMP_REGION")"

if [ -n "$SAM_PARAM_BUILD_DIR" ]; then
  set -- "$@" --build-dir "$(eval "echo $SAM_PARAM_BUILD_DIR")"
fi
if [ -n "$SAM_PARAM_BASE_DIR" ]; then
  set -- "$@" --base-dir "$(eval "echo $SAM_PARAM_BASE_DIR")"
fi
if [ "$SAM_PARAM_CONTAINER" = 1 ]; then
  set -- "$@" --use-container
fi
if [ "$SAM_PARAM_DEBUG" = 1 ]; then
  set -- "$@" --debug
fi

sam build "$@"