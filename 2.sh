#2.sh#Установка mysql 8.0 и wordpress на master
#Все работает, далее удаляем под установку wordpress
rm -rf /var/www/html/wordpress/index.php
#Устанавливаем ключ для mysql, что бы не было ошибки с GPG-ключом
rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022
#Установка репозитория Oracle MySQL 8.0
rpm -Uvh https://repo.mysql.com/mysql80-community-release-el7-3.noarch.rpm
# Включаем репозиторий
sed -i 's/enabled=1/enabled=0/' /etc/yum.repos.d/mysql-community.repo
# Устанавливаем MySQL
yum --enablerepo=mysql80-community install mysql-community-server

# Запускаем mysqld
systemctl start mysqld
systemctl enable mysqld

#Установка Wordpress
cd /var/www/html/
wget https://ru.wordpress.org/latest-ru_RU.tar.gz
 tar xzvf latest-ru_RU.tar.gz
 rm -rf latest-ru_RU.tar.gz
 chown -R apache:apache /var/www/html/*
 
#nano  /etc/my.cnf
#server_id = 1
#log_bin = /var/log/mysql/mysql-bin.log
mv /etc/my.cnf /etc/my.cnf.old
wget -P /etc/ https://raw.githubusercontent.com/evgeniy-romanov/backup/main/my.cnf
#nano  /etc/my.cnf
#server_id = 1
#log_bin = /var/log/mysql/mysql-bin.log
 
 mkdir /var/log/mysql
chown mysql:mysql /var/log/mysql
systemctl restart mysqld
