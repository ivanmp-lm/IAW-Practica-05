#!/bin/bash

#--VARIABLES PARA MYSQL--
DB_ROOT_PASSWD=root
#--VARIABLES PARA MYSQL--

#-----------------
#Instalación MySQL
#-----------------

#Actualizar repositorios
apt update

#Configurar opciones previa instalación de phpMyAdmin
echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections
echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/app-pass password $AUTOGENERATED_PASSWD" |debconf-set-selections
echo "phpmyadmin phpmyadmin/app-password-confirm password $AUTOGENERATED_PASSWD" | debconf-set-selections

#Instalar MySQL
apt install mysql-server -y

#Cambiar contraseña en MySQL
mysql -u root <<< "ALTER USER 'root'@'localhost' IDENTIFIED WITH caching_sha2_password BY '$DB_ROOT_PASSWD';"
mysql -u root <<< "FLUSH PRIVILEGES;"

#Clonar repositorio de la aplicación propuesta
cd /home/ubuntu/
rm -rf iaw-practica-lamp
git clone https://github.com/josejuansanchez/iaw-practica-lamp

#Importar el script de creación de la base de datos
mysql -u root -p$DB_ROOT_PASSWD < /home/ubuntu/iaw-practica-lamp/db/database.sql

#Eliminar el resto de archivos que no son necesarios
rm -rf iaw-practica-lamp