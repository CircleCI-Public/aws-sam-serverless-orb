#!/bin/bash
cd /tmp || true
if [[ $EUID == 0 ]]; then export SUDO=""; else # Check if we are root
  export SUDO="sudo"
fi

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

if [[ $ORB_STR_VERSION == "latest" ]]; then
  echo "Installing latest version of SAM CLI"
  curl -L "https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip" -o aws-sam-cli-linux-x86_64.zip
else
  echo "Installing SAM CLI version $ORB_STR_VERSION"
  curl -L "https://github.com/aws/aws-sam-cli/releases/download/v${ORB_STR_VERSION}/aws-sam-cli-linux-x86_64.zip" -o aws-sam-cli-linux-x86_64.zip
fi
unzip aws-sam-cli-linux-x86_64.zip -d sam-installation
$SUDO ./sam-installation/install
which sam
# shellcheck disable=SC2016
echo 'export PATH=$PATH:/usr/local/bin/sam' >>"$BASH_ENV"
sam --version
