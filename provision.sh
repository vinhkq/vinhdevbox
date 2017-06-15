echo '==============================='
echo '======Development Tools========'
echo '==============================='
yum install -y deltarpm
yum install -y epel-release
yum groupinstall "Development tools"
yum -y update

echo '==============================='
echo '==========Setup Nginx=========='
echo '==============================='
cp /vagrant/config/setup/nginx.repo /etc/yum.repos.d/nginx.repo
sudo yum install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx
sudo firewall-cmd --permanent --zone=public --add-service=http
sudo firewall-cmd --permanent --zone=public --add-service=https
sudo firewall-cmd --reload
# Overwrite config
cp -R /vagrant/config/setup/default.conf /etc/nginx/conf.d/default.conf

echo '==============================='
echo '=========Setup MariaDB========='
echo '==============================='
cp /vagrant/config/setup/mariadb.repo /etc/yum.repos.d/mariadb.repo
sudo yum install -y MariaDB-server MariaDB-client
sudo systemctl start mariadb
sudo systemctl enable mariadb
# Set Root password
mysqladmin -u root password root

echo '==============================='
echo '=========Setup PHP-FPM========='
echo '==============================='
sudo rpm -Uvh http://rpms.remirepo.net/enterprise/remi-release-7.rpm
sudo yum -y install yum-utils
sudo yum -y update
sudo yum-config-manager --enable remi-php71
sudo yum --enablerepo=remi,remi-php71 -y install php-fpm php-common install php-opcache php-pecl-apcu php-cli php-pear php-pdo php-mysqlnd php-pgsql php-pecl-mongodb php-pecl-redis php-pecl-memcache php-pecl-memcached php-gd php-mbstring php-mcrypt php-xml
sudo systemctl start php-fpm
sudo systemctl enable php-fpm
# Setup PHP for Nginx
nginx_conf="/etc/nginx/nginx.conf"
sudo sed -i "s|user  nginx|user  vagrant|" $nginx_conf
php_fpm="/etc/php-fpm.d/www.conf"
sudo sed -i "s|user = apache|user = vagrant|" $php_fpm && \
sudo sed -i "s|group = apache|group = vagrant|" $php_fpm && \
sudo sed -i "s|listen = 127.0.0.1:9000|listen = /var/run/php-fpm/php-fpm.sock|" $php_fpm && \
sudo sed -i "s|;listen.owner = nobody|listen.owner = vagrant|" $php_fpm && \
sudo sed -i "s|;listen.group = nobody|listen.group = vagrant|" $php_fpm
sudo systemctl restart php-fpm
sudo systemctl restart nginx

# echo '==============================='
# echo '===========Setup NVM==========='
# echo '==============================='
# sudo wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | NVM_DIR=/usr/local/nvm bash
# echo "export NVM_DIR=\"\$HOME/.nvm\"" >> .bashrc
# echo "[ -s \"\$NVM_DIR/nvm.sh\" ] && . \"\$NVM_DIR/nvm.sh\"" >> .bashrc
# echo "[ -s \"\$NVM_DIR/bash_completion\" ] && \. \"\$NVM_DIR/bash_completion\"" >> .bashrc

# source ~/.bashrc
# command -v nvm

echo '==============================='
echo '==========Setup NodeJS========='
echo '==============================='
curl -sL https://rpm.nodesource.com/setup_7.x | sudo -E bash -
sudo yum install -y nodejs

source ~/.bashrc
source ~/.bash_profile

echo '==============================='
echo '=======Setup Server Block======'
echo '==============================='

