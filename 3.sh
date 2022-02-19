#3.sh# для  мастера всё и для слейва без wordpress
# Удаляем  конфигурационный файл auto.cnf
rm -rf /var/lib/mysql/auto.cnf
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
