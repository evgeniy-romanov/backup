#4.sh#Мониторинг
#Установка и настройка мониторинга
#Скачиваем Prometheus
curl -LO https://github.com/prometheus/prometheus/releases/download/v2.26.0/prometheus-2.26.0.linux-amd64.tar.gz 
mkdir prometheus
mv prometheus-2.26.0.linux-amd64.tar.gz  prometheus/
cd /root/prometheus
#Разархивируем  
tar -xvf prometheus-2.26.0.linux-amd64.tar.gz
#Удаляем архив
#rm –rf prometheus-2.26.0.linux-amd64.tar.gz
#Создадим пользователя из под которого будет работать прометеус
useradd  --no-create-home  --shell /usr/sbin/nologin prometheus
#Создадим пользователя из под которого будет работать node-exporter
useradd  --no-create-home  --shell /bin/false node_exporter
#Создадим директории для Prometheus
mkdir {/etc/,/var/lib/}prometheus
#ls {/etc/,/var/lib/}prometheus

#Скопируем утилиты prometheus и promtool в /usr/local/bin/
#ls prometheus-2.26.0.linux-amd64/
cp  -iv  prometheus-2.26.0.linux-amd64/prom{etheus,tool}  /usr/local/bin/
#Скопируем директории для того чтобы передать права пользователя Prometheus и настроить его запуск
cp -riv prometheus-2.26.0.linux-amd64/{console{s,_libraries},prometheus.yml} /etc/prometheus/
#Передадим права пользователя для Prometheus
chown -Rv prometheus: /usr/local/bin/prom{etheus,tool} /etc/prometheus/ /var/lib/prometheus/

rm -rf /etc/systemd/system/prometheus.service

wget -P /etc/systemd/system/ https://raw.githubusercontent.com/evgeniy-romanov/backup/main/prometheus.service


#Запустим демон prometheus.service 
systemctl daemon-reload && systemctl start prometheus.service && systemctl status prometheus
#============================================================
#Скачиваем node_exporter (модуль для prometheus, который позволяет собирать информацию о состоянии машин, агент программа для отслеживания состояния машин)
curl -LO https://github.com/prometheus/node_exporter/releases/download/v1.1.2/node_exporter-1.1.2.linux-amd64.tar.gz

#Разархивируем  
tar -xvf node_exporter-1.1.2.linux-amd64.tar.gz
#Удаляем архив
#rm -rf node_exporter-1.1.2.linux-amd64.tar.gz
#Допишем в конфиг /etc/prometheus/prometheus.yml
wget https://raw.githubusercontent.com/evgeniy-romanov/backup/main/prometheus.yml
mv prometheus.yml /etc/prometheus/prometheus.yml	
systemctl restart prometheus.service && systemctl status prometheus.service	

# Устанавливаем node_exporter 
cp -vi node_exporter-1.1.2.linux-amd64/node_exporter /usr/local/bin/node_exporter

#Передаем права node_exporter одноименному пользователю
chown node_exporter: /usr/local/bin/node_exporter

#Создадим юнит для node_exporter

wget /etc/systemd/system/ https://raw.githubusercontent.com/evgeniy-romanov/backup/main/node_exporter.service
mv  node_exporter.service /etc/systemd/system/node_exporter.service

#Перезапускаем все демоны и запускаем node_exporter
systemctl daemon-reload
systemctl start node_exporter.service
systemctl status node_exporter.service

#Проверим работу node_exporter и копируем любой запрос 
#http://192.168.31.226:9100/metrics
#копируем запрос
#node_filesystem_files_free{device="/dev/mapper/centos-root",fstype="xfs",mountpoint="/"}
#вставляем его в поиск и увидим отобразится код запроса
#192.168.31.226:9090
#====================================================
#Установка grafana
#Сделаем настройку графаны (скачиваем)
curl -LO https://dl.grafana.com/oss/release/grafana-8.3.4-1.x86_64.rpm

#Устанавливаем скачанный пакет
yum install ./grafana-8.3.4-1.x86_64.rpm
#Перезапускаем все демоны и запускаем grafana-server
systemctl daemon-reload && systemctl start grafana-server && systemctl status grafana-server
