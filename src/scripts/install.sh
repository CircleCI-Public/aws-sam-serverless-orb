cd /opt/$USER/.pyenv/plugins/python-build/../.. && git pull && cd -
pyenv install 3.8.5
pip3 install --user virtualenv
python3 -m venv env
source env/bin/activate
pip3 install aws-sam-cli
sam --version
deactivate
sam --version