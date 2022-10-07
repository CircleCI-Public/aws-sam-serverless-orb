#!/bin/bash
cd /tmp || true
if [[ $EUID == 0 ]]; then export SUDO=""; else # Check if we are root
  export SUDO="sudo";
fi

if [[ $SAM_PARAM_VERSION == "latest" ]]; then
  echo "Installing latest version of SAM CLI"
  curl -L "https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip" -o aws-sam-cli-linux-x86_64.zip
else
  echo "Installing SAM CLI version $SAM_PARAM_VERSION"
  curl -L "https://github.com/aws/aws-sam-cli/releases/download/v${SAM_PARAM_VERSION}/aws-sam-cli-linux-x86_64.zip" -o aws-sam-cli-linux-x86_64.zip
fi
unzip aws-sam-cli-linux-x86_64.zip -d sam-installation
$SUDO ./sam-installation/install
which sam
echo "export PATH=$PATH:/usr/local/bin/sam" >> "$BASH_ENV"
sam --version