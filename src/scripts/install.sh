if echo "$OSTYPE "| grep darwin > /dev/null 2>&1; then
    echo "Brew is installed"
elif  grep Debian /etc/issue > /dev/null 2>&1 || grep Ubuntu /etc/issue > /dev/null 2>&1; then
    echo "Debian"
    if ! command -v brew >/dev/null 2>&1; then
        curl -fsSL "https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh" | bash
        /home/linuxbrew/.linuxbrew/bin/brew shellenv >> "$BASH_ENV"
    fi
    echo "Brew is installed"
fi
# Install twice as bug patch. See https://github.com/CircleCI-Public/aws-sam-serverless-orb/issues/20
brew tap aws/tap
brew install aws-sam-cli
echo "Second install for bug patch"
echo 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)' >> $BASH_ENV
eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
brew install aws-sam-cli
sam --version