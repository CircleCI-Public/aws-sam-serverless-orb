pip3 install aws-sam-cli --user
echo 'export PATH=$PATH:~/.local/bin' >>$BASH_ENV
export PATH=$PATH:~/.local/bin
sam --version