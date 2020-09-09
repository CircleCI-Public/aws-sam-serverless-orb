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
brew install aws/tap/aws-sam-cli
brew install aws/tap/aws-sam-cli
sam --version