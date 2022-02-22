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

#Создаем пользователя mysql
# Выясняем временный пароль MySQL
grep "A temporary password" /var/log/mysqld.log
# Запускаем скрипт безопасности для MySQL
mysql_secure_installation
Qaz/2152

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

#Настройка времени
yum install ntpdate
ntpdate -u pool.ntp.org
date
#Проверим работу node_exporter и копируем любой запрос 
#http://192.168.31.226:9100/metrics
#копируем запрос
#node_filesystem_files_free{device="/dev/mapper/centos-root",fstype="xfs",mountpoint="/"}
#вставляем его в поиск и увидим отобразится код запроса
#192.168.31.226:9090
#Настраиваем систему мониторинга
192.168.31.226:3000
admin
admin
Configuration - data sources - Prometheus - http://localhost:9090 - save 
+ - import - 1860 - load - выбираем prometheus - import
==============================================
#Установка логирования
#Скачаем скрипт logging.sh и запустим его
wget https://raw.githubusercontent.com/evgeniy-romanov/logging/main/logging.sh
sh logging.sh

#Остановим Апаче и проверим есть ли папка с логами
systemctl stop httpd
ls -l /var/log/nginx/

#Обновляемся в браузере, что бы была ошибка nginx и проверим в логах
ls -l /var/log/nginx/
#Запускаем Апаче и идем в браузер ip:5601
systemctl start httpd
192.168.31.226:5601
#Создать
menu - discover - create index pattern 
name=weblogs*
Timestamp field=Timestamp field
create index pattern
#Снова идем в discover и создадим Dashboard
menu - discover
#Переходим во вкладку Dashboard
create new dashboard - create visualization
#График показывает частоту запросов wget в браузере
выбираем в поиске под веблогом request.keyword + (добавить) - Bar horizontal - Show dates last 24 hours
#сохраним visualization
save and return

#Создадим еще один Dashboard, который показывает коды ответов ошибок
create visualization
Bar Donat
#В правой панели вводим
slice by=response
size by=records
#сохраним visualization
save and return










