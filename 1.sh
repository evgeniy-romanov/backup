#1.sh#Устанавливаем необходимые репозитории и обновляем
yum install epel-release 

#Устанавливаем необходимые программы
yum install nano nginx httpd 
#Cкачиваем скрипт selinux и запускаем
#wget https://raw.githubusercontent.com/evgeniy-romanov/backup/main/Script_selinux.sh
#setenforce 0
#sh Script_selinux.sh
#Отключаем Firewall
systemctl disable firewalld
systemctl stop firewalld

#Устанавливаем php 7.4
yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum --enablerepo=remi-php74 install php php-pdo php-fpm php-gd php-mbstring php-mysql php-curl php-mcrypt php-json -y
php -v

#Изменим порт в конфигурационном файле httpd с 80 на 8080, 8081, 8082 в nano /etc/httpd/conf/httpd.conf:
mv /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.old
wget -P /etc/httpd/conf/ https://raw.githubusercontent.com/evgeniy-romanov/backup/main/httpd.conf 

systemctl start httpd
ss -ntlp

#Удаляем файл welcome.conf в директории /etc/httpd/conf.d
rm -rf /etc/httpd/conf.d/welcome.conf

#Создаем файл wordpress.conf в директории /etc/httpd/conf.d
wget -P /etc/httpd/conf.d/ https://raw.githubusercontent.com/evgeniy-romanov/backup/main/wordpress.conf

#В /etc/nginx/conf.d/ создаем файл wordpress.conf 
wget -P /etc/nginx/conf.d/ https://raw.githubusercontent.com/evgeniy-romanov/backup/main/wordpress1.conf
#mv /etc/nginx/conf.d/wordpress1.conf /etc/nginx/conf.d/wordpress.conf

#Заменим конигурационный файл закомментированным /etc/nginx/nginx.conf
mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.old
wget -P /etc/nginx/ https://raw.githubusercontent.com/evgeniy-romanov/backup/main/nginx.conf

mkdir /var/www/html/wordpress
echo "<?php phpinfo(); ?>" > /var/www/html/wordpress/index.php
chown -R apache:apache /var/www/html/wordpress

# Перезапускаем nginx, httpd:
systemctl restart nginx
systemctl enable nginx
systemctl restart httpd
systemctl enable httpd
