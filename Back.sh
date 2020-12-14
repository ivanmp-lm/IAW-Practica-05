#!/bin/bash

#--VARIABLES PARA MYSQL--
DB_ROOT_PASSWD=root
#--VARIABLES PARA MYSQL--

#-----------------
#Instalación MySQL
#-----------------

#Actualizar repositorios
apt update

#Instalar MySQL
apt install mysql-server -y

#Añadir archivo mysqld.cnf
cp mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf

#Cambiar contraseña en MySQL
mysql -u root -p$DB_ROOT_PASSWD <<< "ALTER USER 'root'@'localhost' IDENTIFIED WITH caching_sha2_password BY '$DB_ROOT_PASSWD';"
mysql -u root -p$DB_ROOT_PASSWD <<< "FLUSH PRIVILEGES;"

#Crear usuarios en MySQL
mysql -u root -p$DB_ROOT_PASSWD <<< "CREATE USER 'ubuntu'@'localhost' IDENTIFIED BY 'root';"
mysql -u root -p$DB_ROOT_PASSWD <<< "GRANT ALL PRIVILEGES ON *.* TO 'ubuntu'@'localhost';"
mysql -u root -p$DB_ROOT_PASSWD <<< "FLUSH PRIVILEGES;"

#Clonar repositorio de la aplicación propuesta
cd /home/ubuntu/
rm -rf iaw-practica-lamp
git clone https://github.com/josejuansanchez/iaw-practica-lamp

#Importar el script de creación de la base de datos
mysql -u root -p$DB_ROOT_PASSWD < /home/ubuntu/iaw-practica-lamp/db/database.sql

#Reiniciar mysql
service mysql restart
