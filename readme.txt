#master и slave
yum install wget tcpdump git
#Cкачиваем скрипт selinux и выключаем
wget https://raw.githubusercontent.com/evgeniy-romanov/backup/main/Script_selinux.sh
sh Selinux*.sh
reboot
===================================
#master
#Cкачиваем скрипт 1.sh и устанавливаем nginx, httpd, php 7.4, загружаем конфигурационные файлы с 
настройкой веб-сервера через обратный прокси сервер, отключаем Firewall
wget https://raw.githubusercontent.com/evgeniy-romanov/backup/main/1.sh
sh 1.sh
ip a
192.168.31.226
#Проверяем в браузере index.php 192.168.31.226

#Cкачиваем скрипт 2.sh и устанавливаем mysql, wordpress
wget https://raw.githubusercontent.com/evgeniy-romanov/backup/main/2.sh
sh 2.sh
#Проверяем в браузере wordpress 192.168.31.226

#Создаем пользователя mysql
# Выясняем временный пароль MySQL
grep "A temporary password" /var/log/mysqld.log
# Запускаем скрипт безопасности для MySQL
mysql_secure_installation
Qaz/2152
mysql -u root -p
Qaz/2152
Далее создаем и назначаем права пользователю для реплики:
CREATE USER replicuser@'%' IDENTIFIED WITH 'caching_sha2_password' BY 'Qaz/2152';
GRANT REPLICATION SLAVE ON *.* TO replicuser@'%';
show master status;
==============================================
#slave 
#Cкачиваем скрипт 3.sh и устанавливаем mysql
wget https://raw.githubusercontent.com/evgeniy-romanov/backup/main/3.sh
sh 3.sh

nano  /etc/my.cnf
server_id = 2

mkdir /var/log/mysql
chown mysql:mysql /var/log/mysql
systemctl restart mysqld

mysql -u root -p
Qaz/2152
#Прописываем в слейве id мастера,  бинлог и позицию бинлога
Stop slave;
CHANGE MASTER TO MASTER_HOST='192.168.31.226', MASTER_USER='replicuser', MASTER_PASSWORD='Qaz/2152', MASTER_LOG_FILE = 'mysql-bin.000001', MASTER_LOG_POS = 702, GET_MASTER_PUBLIC_KEY = 1;
После этого запускаем репликацию на Слейве:
START SLAVE;
SHOW SLAVE STATUS\G
=====================================================
#master
#создаем бд wordpress, пользователя wordpressuser и назначаем ему привелегии для бд wordpress
mysql  -u root  -p
Qaz/2152
CREATE DATABASE wordpress;
CREATE USER wordpressuser@localhost IDENTIFIED BY 'Tfhjvfyjdtt/86';
GRANT ALL PRIVILEGES ON wordpress.* TO wordpressuser@localhost;
FLUSH PRIVILEGES;
#Заходим в браузер вводим ip 192.168.31.226, вводим данные mysql wordpress и устанавливаем
DATABASE=wordpress
Db_user=wordpressuser
Db_password=Tfhjvfyjdtt/86
localhost

show master status;
=======================================================
#slave
#Сравниваем позиции бинлога в репликации
SHOW SLAVE STATUS\G
exit
#Скачиваем скрипт бекапа mysql, запускаем и проверяем
wget https://raw.githubusercontent.com/evgeniy-romanov/backup/main/script_mysql_backup.sh
sh script_mysql_backup.sh
ls -l
========================================================
#master
#Скачиваем и устанавливаем систему мониторинга
wget https://raw.githubusercontent.com/evgeniy-romanov/backup/main/4.sh
sh 4.sh
ss -ntlp
#Проверяем работу в браузере
192.168.31.226:9090
http://192.168.31.226:9100/metrics
#Настраиваем систему мониторинга
192.168.31.226:3000

#Передадим файл readme.txt в github


ssh-keygen
cat /root/ .ssh/id_rsa.pub
git clone git@github.com:evgeniy-romanov/backup.git
cd backup/
nano readme.txt

git status
git add readme.txt
git commit -m "recovery readme.txt"
