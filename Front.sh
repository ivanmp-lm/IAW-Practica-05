#!/bin/bash

#--VARIABLES PARA GOACCESS--
HTPASSWD_DIR=/home/ubuntu
HTPASSWD_USER=usuario
HTPASSWD_PASSWD=usuario
#--VARIABLES PARA GOACCESS--

#-----------------
#Instalación pila LAMP - Front End
#-----------------

#Actualizar repositorios
apt update

#Instalar apache2
apt install apache2 -y

#-----------------
#Instalación de aplicaciones necesarias
#-----------------

#Instalar php
apt install php libapache2-mod-php php-mysql -y 

#Instalar phpMyAdmin
apt install phpmyadmin php-mbstring php-zip php-gd php-json php-curl -y

#Clonar repositorio de la aplicación propuesta
cd /var/www/html/
rm -rf iaw-practica-lamp
git clone https://github.com/josejuansanchez/iaw-practica-lamp
mv /var/www/html/iaw-practica-lamp/src/* /var/www/html/

#Eliminar el archivo index.html
rm -rf index.html

#Eliminar el contenido que no sea útil
rm -rf /var/www/html/index.html
rm -rf /var/www/html/iaw-practica-lamp

# Cambiar los permisos
chown www-data:www-data * -R

#Instalar GoAccess
echo "deb http://deb.goaccess.io/ $(lsb_release -cs) main" | sudo tee -a /etc/apt/sources.list.d/goaccess.list
wget -O - https://deb.goaccess.io/gnugpg.key | sudo apt-key add -
sudo apt-get update
sudo apt-get install goaccess -y

#Crear un directorio para consultar las estadísticas
mkdir -p /var/www/html/stats
nohup goaccess /var/log/apache2/access.log -o /var/www/html/stats/index.html --log-format=COMBINED --real-time-html &
htpasswd -b -c $HTPASSWD_DIR/.htpasswd $HTPASSWD_USER $HTPASSWD_PASSWD

#Crear archivo 000-default.conf
cp /home/ubuntu/000-default.conf /etc/apache2/sites-available/
systemctl restart apache2
