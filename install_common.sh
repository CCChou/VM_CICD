#!/bin/bash

sudo yum install -y wget

# install wget
sudo wget -O ~/mysql80-community-release-el7-3.noarch.rpm https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm

# install mysql
sudo yum localinstall -y ~/mysql80-community-release-el7-3.noarch.rpm
sudo yum install -y mysql-community-server
sudo systemctl start mysqld
sudo systemctl enable mysqld

# change mysql default password
PWD=$(sudo grep 'temporary password' /var/log/mysqld.log | awk '{print $13}')
mysql -u root -p$PWD --connect-expired-password << EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '1qaz@WSX';
FLUSH PRIVILEGES;
EOF