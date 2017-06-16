
echo '==============================='
echo '===========Setup NVM==========='
echo '==============================='
wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash
echo "export NVM_DIR=\"\$HOME/.nvm\"" >> ~/.bashrc
echo "[ -s \"\$NVM_DIR/nvm.sh\" ] && . \"\$NVM_DIR/nvm.sh\"" >> ~/.bashrc
echo "[ -s \"\$NVM_DIR/bash_completion\" ] && \. \"\$NVM_DIR/bash_completion\"" >> ~/.bashrc

# Run bashrc config
source ~/.bashrc

command -v nvm
nvm install node
nvm use node
node -v
npm -v



