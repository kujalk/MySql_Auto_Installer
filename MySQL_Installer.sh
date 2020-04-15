############################################################################################################
#This script is used to auto install MySql community server in AWS Linux EC2 and other Centos/RedHat OS    #
#It will install the MySql and reset password to 'new_pass@123' and create a database from the db.txt file #
############################################################################################################

#!/bin/bash

rpm -Uvh https://repo.mysql.com/mysql80-community-release-el7-3.noarch.rpm

sed -i 's/enabled=1/enabled=0/' /etc/yum.repos.d/mysql-community.repo

yum --enablerepo=mysql80-community install mysql-community-server -y

service mysqld start

pass=$(grep "A temporary password" /var/log/mysqld.log | awk '{print $NF}')

echo "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'new_pass@123';" | mysql -u root --password=$pass --connect-expired-password

echo "show databases;" | mysql -u root --password="new_pass@123"

cat db.txt | mysql -u root --password="new_pass@123"
