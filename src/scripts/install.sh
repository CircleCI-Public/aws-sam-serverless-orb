#!/bin/bash
cd /tmp || true

eval "${SCRIPT_UTILS}"
detect_arch
detect_os
set_sudo

# Check if the AWS CLI is installed
if ! command -v aws &>/dev/null; then
  echo "AWS CLI could not be found. Please install it before initiating the SAM CLI."
  echo
  echo "Use the circleci/aws-cli orb to install the AWS CLI."
  echo "https://circleci.com/developer/orbs/orb/circleci/aws-sam-serverless#usage-examples"
  echo
  echo "Job example:"
  echo "
    jobs:
      build_app:
        executor: sam/default
        steps:
          - checkout
          - aws-cli/setup
          - sam/install
  "
  echo
  echo "Workflow example:"
  echo "
    workflows:
      test_and_deploy:
        jobs:
          - sam/deploy:
              pre-steps:
                - aws-cli/setup
  "
  exit 1
fi

install_sam_cli(){
  if [[ $ORB_STR_VERSION == "latest" ]]; then
    echo "Installing latest version of SAM CLI"
    curl -L "https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-${PLATFORM}-${ARCH}.${FILE_EXTENSION}" -o aws-sam-cli-"${PLATFORM}"-"${ARCH}"."${FILE_EXTENSION}"
  else
    echo "Installing SAM CLI version $ORB_STR_VERSION"
    curl -L "https://github.com/aws/aws-sam-cli/releases/download/v${ORB_STR_VERSION}/aws-sam-cli-${PLATFORM}-${ARCH}.${FILE_EXTENSION}" -o aws-sam-cli-"${PLATFORM}"-"${ARCH}"."${FILE_EXTENSION}"
  fi
  ls -la
  if [ "${PLATFORM}" == "linux" ]; then
    unzip aws-sam-cli-linux-"${ARCH}".zip -d sam-installation
    $SUDO ./sam-installation/install
  elif [ "${PLATFORM}" == "macos" ]; then
    $SUDO installer -pkg aws-sam-cli-macos-"${ARCH}".pkg -target /
  fi
  echo
  echo "Verifying AWS SAM CLI installation..."
  set -x
  which sam
  sam --version
  set +x
}
install_sam_cli
