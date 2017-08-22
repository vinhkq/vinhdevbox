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
sudo wget https://github.com/git/git/archive/v2.14.0.tar.gz \ -O git-2.14.0.tar.gz
sudo tar -zxf v2.14.0.tar.gz
cd git-2.14.0/
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
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

echo '==============================='
echo '========Setup PostgreSQL======='
echo '==============================='
sudo yum -y install https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-centos96-9.6-3.noarch.rpm
sudo yum -y install postgresql96-server postgresql96
sudo /usr/pgsql-9.6/bin/postgresql96-setup initdb
sudo systemctl start postgresql-9.6
sudo systemctl enable postgresql-9.6
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
wget http://download.redis.io/releases/redis-3.2.9.tar.gz
tar -xvzf redis-3.2.9.tar.gz
cd redis-3.2.9
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
# cd /usr/local
# sudo wget https://github.com/rbenv/rbenv/archive/master.zip
# unzip master.zip
# mv rbenv-master rbenv
git clone git://github.com/sstephenson/rbenv.git /usr/local/rbenv
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
wget https://www.python.org/ftp/python/3.6.2/Python-3.6.2.tgz
tar xzf Python-3.6.2.tgz
cd Python-3.6.2
./configure
make altinstall
cd /opt/
sudo cp /usr/local/bin/python3.6 /usr/bin/
python3.6 -m easy_install pip

echo '==============================='
echo '========Disable Firewall======='
echo '==============================='
sudo systemctl stop firewalld
sudo systemctl disable firewalld

echo '==============================='
echo '=======Setup Server Block======'
echo '==============================='

