echo '==============================='
echo '======Development Tools========'
echo '==============================='
yum -y update
yum install -y deltarpm
yum install -y epel-release
# yum groupinstall "Development tools"
# yum install -y gettext-devel
yum install -y autoconf gcc curl-devel expat-devel openssl-devel zlib-devel perl-devel perl-CPAN

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

# Using NVM instead
# echo '==============================='
# echo '==========Setup NodeJS========='
# echo '==============================='
# curl -sL https://rpm.nodesource.com/setup_7.x | sudo -E bash -
# sudo yum install -y nodejs

echo '==============================='
echo '===========Setup GIT==========='
echo '==============================='
sudo wget https://github.com/git/git/archive/v2.13.1.tar.gz \ -O git-2.13.1.tar.gz
sudo tar -zxf v2.13.1.tar.gz
cd git-2.13.1/
make clean
make configure
./configure --prefix=/usr/local/git
make
make install
echo "export PATH=\$PATH:/usr/local/git/bin" >> /etc/bashrc

echo '==============================='
echo '=========Setup Composer========'
echo '==============================='
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

echo '==============================='
echo '========Setup PostgreSQL======='
echo '==============================='
sudo yum install https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-centos96-9.6-3.noarch.rpm
sudo yum install postgresql96-server postgresql96
sudo /usr/pgsql-9.6/bin/postgresql96-setup initdb
sudo systemctl start postgresql-9.6
sudo systemctl enable postgresql-9.6

# Run bashrc config
source /etc/bashrc

echo '==============================='
echo '=======Setup Server Block======'
echo '==============================='

