echo '==============================='
echo '======Development Tools========'
echo '==============================='
cd /opt/
yum -y update
yum install -y deltarpm
yum install -y epel-release
yum install -y wget
yum install -y unzip
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
nginx_conf="/etc/nginx/nginx.conf"
sudo sed -i "s|user  nginx|user  vagrant|" $nginx_conf

echo '==============================='
echo '=========Setup MariaDB========='
echo '==============================='
cp /vagrant/config/setup/mariadb.repo /etc/yum.repos.d/mariadb.repo
sudo yum install -y MariaDB-server MariaDB-client
sudo systemctl start mariadb
sudo systemctl enable mariadb
# Set Root password
mysqladmin -u root password root
mysql --user="root" --password="root" -e "GRANT ALL ON *.* TO 'root'@'0.0.0.0' IDENTIFIED BY 'root' WITH GRANT OPTION;"
mysql --user="root" --password="root" -e "GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY 'root' WITH GRANT OPTION;"
sudo systemctl restart mariadb

echo '==============================='
echo '=========Setup PHP-FPM========='
echo '==============================='
sudo rpm -Uvh http://rpms.remirepo.net/enterprise/remi-release-7.rpm
sudo yum -y install yum-utils
sudo yum -y update
# sudo yum-config-manager --enable remi-php71

# Setup PHP 5.5 for Nginx
sudo yum -y install php55-php-bcmath php55-php-cli php55-php-common php55-php-fpm php55-php-gd php55-php-intl php55-php-mbstring php55-php-mcrypt php55-php-mysqlnd php55-php-opcache php55-php-pdo php55-php-pear php55-php-pecl-uploadprogress php55-php-soap php55-php-xml php55-php-xmlrpc php55-php-pecl-memcache php55-php-pecl-memcached php55-php-pgsql php55-php-pecl-mongodb php55-php-pecl-redis
php55_php_fpm="/opt/remi/php55/root/etc/php-fpm.d/www.conf"
sudo sed -i "s|user = apache|user = vagrant|" $php55_php_fpm && \
sudo sed -i "s|group = apache|group = vagrant|" $php55_php_fpm && \
sudo sed -i "s|listen = 127.0.0.1:9000|listen = 127.0.0.1:9005|" $php55_php_fpm && \
sudo sed -i "s|;listen.owner = nobody|listen.owner = vagrant|" $php55_php_fpm && \
sudo sed -i "s|;listen.group = nobody|listen.group = vagrant|" $php55_php_fpm
sudo systemctl start php55-php-fpm
sudo systemctl enable php55-php-fpm

# Setup PHP 5.6 for Nginx
sudo yum -y install php56-php-bcmath php56-php-cli php56-php-common php56-php-fpm php56-php-gd php56-php-intl php56-php-mbstring php56-php-mcrypt php56-php-mysqlnd php56-php-opcache php56-php-pdo php56-php-pear php56-php-pecl-uploadprogress php56-php-soap php56-php-xml php56-php-xmlrpc php56-php-pecl-memcache php56-php-pecl-memcached php56-php-pgsql php56-php-pecl-mongodb php56-php-pecl-redis
php56_php_fpm="/opt/remi/php56/root/etc/php-fpm.d/www.conf"
sudo sed -i "s|user = apache|user = vagrant|" $php56_php_fpm && \
sudo sed -i "s|group = apache|group = vagrant|" $php56_php_fpm && \
sudo sed -i "s|listen = 127.0.0.1:9000|listen = 127.0.0.1:9006|" $php56_php_fpm && \
sudo sed -i "s|;listen.owner = nobody|listen.owner = vagrant|" $php56_php_fpm && \
sudo sed -i "s|;listen.group = nobody|listen.group = vagrant|" $php56_php_fpm
sudo systemctl start php56-php-fpm
sudo systemctl enable php56-php-fpm

# Setup PHP 7.0 for Nginx
sudo yum -y install php70-php-bcmath php70-php-cli php70-php-common php70-php-fpm php70-php-gd php70-php-intl php70-php-mbstring php70-php-mcrypt php70-php-mysqlnd php70-php-opcache php70-php-pdo php70-php-pear php70-php-pecl-uploadprogress php70-php-soap php70-php-xml php70-php-xmlrpc php70-php-pecl-memcache php70-php-pecl-memcached php70-php-pgsql php70-php-pecl-mongodb php70-php-pecl-redis
php70_php_fpm="/etc/opt/remi/php70/php-fpm.d/www.conf"
sudo sed -i "s|user = apache|user = vagrant|" $php70_php_fpm && \
sudo sed -i "s|group = apache|group = vagrant|" $php70_php_fpm && \
sudo sed -i "s|listen = 127.0.0.1:9000|listen = 127.0.0.1:9007|" $php70_php_fpm && \
sudo sed -i "s|;listen.owner = nobody|listen.owner = vagrant|" $php70_php_fpm && \
sudo sed -i "s|;listen.group = nobody|listen.group = vagrant|" $php70_php_fpm
sudo systemctl start php70-php-fpm
sudo systemctl enable php70-php-fpm

# Setup PHP 7.1 for Nginx
sudo yum -y install php71-php-bcmath php71-php-cli php71-php-common php71-php-fpm php71-php-gd php71-php-intl php71-php-mbstring php71-php-mcrypt php71-php-mysqlnd php71-php-opcache php71-php-pdo php71-php-pear php71-php-pecl-uploadprogress php71-php-soap php71-php-xml php71-php-xmlrpc php71-php-pecl-memcache php71-php-pecl-memcached php71-php-pgsql php71-php-pecl-mongodb php71-php-pecl-redis
php71_php_fpm="/etc/opt/remi/php71/php-fpm.d/www.conf"
sudo sed -i "s|user = apache|user = vagrant|" $php71_php_fpm && \
sudo sed -i "s|group = apache|group = vagrant|" $php71_php_fpm && \
sudo sed -i "s|listen = 127.0.0.1:9000|listen = 127.0.0.1:9008|" $php71_php_fpm && \
sudo sed -i "s|;listen.owner = nobody|listen.owner = vagrant|" $php71_php_fpm && \
sudo sed -i "s|;listen.group = nobody|listen.group = vagrant|" $php71_php_fpm
sudo systemctl start php71-php-fpm
sudo systemctl enable php71-php-fpm

sudo systemctl restart nginx

# Using PHP 7.1 as default PHP
ln -s /usr/bin/php71 /usr/bin/php

# Using NVM instead
# echo '==============================='
# echo '==========Setup NodeJS========='
# echo '==============================='
# curl -sL https://rpm.nodesource.com/setup_7.x | sudo -E bash -
# sudo yum install -y nodejs

echo '==============================='
echo '===========Setup GIT==========='
echo '==============================='
sudo wget https://github.com/git/git/archive/v2.15.0.tar.gz \ -O git-2.15.0.tar.gz
sudo tar -zxf v2.15.0.tar.gz
cd git-2.15.0/
make clean
make configure
./configure --prefix=/usr/local/git
make
make install
echo "export PATH=\$PATH:/usr/local/git/bin" >> /etc/bashrc
# Run bashrc config
source /etc/bashrc
cd /opt/

echo '==============================='
echo '=========Setup Composer========'
echo '==============================='
curl -sS https://getcomposer.org/installer | php71
mv composer.phar /usr/local/bin/composer

echo '==============================='
echo '========Setup PostgreSQL======='
echo '==============================='
sudo yum -y install https://download.postgresql.org/pub/repos/yum/10/redhat/rhel-7-x86_64/pgdg-centos10-10-2.noarch.rpm
sudo yum -y install postgresql10-server postgresql10
sudo /usr/pgsql-10/bin/postgresql-10-setup initdb
sudo systemctl start postgresql-10
sudo systemctl enable postgresql-10
sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD '{root}';"
#sudo chown -R postgres /home/vagrant
pg_hba="/var/lib/pgsql/9.6/data/pg_hba.conf"
pg_conf="/var/lib/pgsql/9.6/data/postgresql.conf"
sudo sed -i "s|peer|trust|" $pg_hba
sudo sed -i "s|ident|trust|" $pg_hba
sudo echo 'host        all        all        192.168.12.1/24        trust' >> $pg_hba
sudo sed -i "s|#listen_addresses = 'localhost'|listen_addresses = '*'|" $pg_conf
sudo systemctl restart postgresql-9.6


echo '==============================='
echo '=========Setup MongoDB========='
echo '==============================='
cp /vagrant/config/setup/mongodb.repo /etc/yum.repos.d/mongodb.repo
sudo yum install -y mongodb-org
sudo systemctl start mongod
sudo systemctl enable mongod
mongo_conf="/etc/mongod.conf"
sudo sed -i "s|bindIp|# bindIp|" $mongo_conf

echo '==============================='
echo '==========Setup Redis=========='
echo '==============================='
wget http://download.redis.io/releases/redis-4.0.2.tar.gz
tar -xvzf redis-4.0.2.tar.gz
cd redis-4.0.2
cd deps
make hiredis lua jemalloc linenoise
make geohash-int
cd ../
make
make install
cd utils
echo | ./install_server.sh
systemctl start redis_6379
systemctl enable redis_6379
redis_conf="/etc/redis/6379.conf"
sudo sed -i "s|bind 127.0.0.1|bind 0.0.0.0|" $redis_conf
systemctl restart redis_6379
cd /opt/

echo '==============================='
echo '=====Install Ruby by Rbenv====='
echo '==============================='
cd /usr/local
sudo wget https://github.com/rbenv/rbenv/archive/master.zip
unzip master.zip
mv rbenv-master rbenv
# git clone git://github.com/sstephenson/rbenv.git /usr/local/rbenv
echo '# rbenv setup' > /etc/profile.d/rbenv.sh
echo 'export RBENV_ROOT=/usr/local/rbenv' >> /etc/profile.d/rbenv.sh
echo 'export PATH="$RBENV_ROOT/bin:$PATH"' >> /etc/profile.d/rbenv.sh
echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh
chmod +x /etc/profile.d/rbenv.sh
source /etc/profile.d/rbenv.sh
git clone https://github.com/sstephenson/ruby-build.git /usr/local/rbenv/plugins/ruby-build
# Run bashrc config
source /etc/bashrc
cd /opt/

echo '==============================='
echo '========Install Python 3======='
echo '==============================='
cd ~/
wget https://www.python.org/ftp/python/3.6.3/Python-3.6.3.tgz
tar xzf Python-3.6.3.tgz
cd Python-3.6.3
./configure
make altinstall
cd /opt/
sudo cp /usr/local/bin/python3.6 /usr/bin/
python3.6 -m easy_install pip

echo '==============================='
echo '=========Install Golang========'
echo '==============================='
wget https://storage.googleapis.com/golang/go1.9.2.linux-amd64.tar.gz
sudo tar -zxvf go1.9.2.linux-amd64.tar.gz -C /usr/local
echo 'export GOROOT=/usr/local/go' | sudo tee -a /etc/profile
echo 'export PATH=$PATH:/usr/local/go/bin:/home/vagrant/go/bin' | sudo tee -a /etc/profile
source /etc/profile
go version
go env
'Debugger'
go get github.com/derekparker/delve/cmd/dlv
source /etc/profile

echo '==============================='
echo '========Disable Firewall======='
echo '==============================='
sudo systemctl stop firewalld
sudo systemctl disable firewalld
