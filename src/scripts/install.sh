cd /opt/$USER/.pyenv/plugins/python-build/../.. && git pull && cd -
pyenv install 3.8.5
pip3 install aws-sam-cli
sam --version