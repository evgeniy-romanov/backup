#!/bin/bash
if [[ $EUID -ne 0 ]]; then
	echo "Запустите скрипт от рута"
	exit 1
else 
echo "Проверка состояния Selinux:" 
getenforce
echo "Выберите, что нужно сделать:"
echo "1 Включить Selinux"
echo "2 Выключить Selinux"
echo "3 Активировать/дезактивировать Selinux в корневом каталоге"
echo "4 Выход"

read doing
case $doing in
1)
setenforce 1
;;
2)
setenforce 0
;;
3)

	Sesys=$(getenforce)
	source /etc/selinux/config

	echo ""
	echo "Конфигурационный файл Selinux находится в состоянии: $Selinux"
	echo ""

	#Проверяем в конфигурационном файле
	if [[ $SELINUX == "disabled" ]]; then
		read -p "Включить Selinux в конфигурационном файле? Yy(да)/Nn(нет)" ch
		if [[ $ch == Y || $ch == y ]]; then
		sed -i 's/SELINUX=disabled/SELINUX=enforcing/g' /etc/selinux/config
		echo "Selinux в конфигурационном файле включен, перезагрузите систему"
		fi
	elif [[ $SELINUX == "enforcing" ]]; then
                read -p "Выключить Selinux в конфигурационном файле? Yy(да)/Nn(нет)" ch
                if [[ $ch == Y || $ch == y ]]; then
                sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
                echo "Selinux в конфигурационном файле выключен, перезагрузите систему"
                fi
	fi

;;
4)
exit 0
;;
*)
echo "Введено неправильное действие"
esac
fi