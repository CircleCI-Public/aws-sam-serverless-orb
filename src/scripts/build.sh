set -o noglob

set -- "$@" --profile "$SAM_PARAM_PROFILE"

if [ -f ".aws-sam/build/template.yaml" ]; then
  echo "Debug: Loading previously built template file"
  set -- "$@" --template-file .aws-sam/build/template.yaml
else
  set -- "$@" --template-file "$(eval "echo $SAM_PARAM_TEMPLATE")"
fi

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