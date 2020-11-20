#!/bin/bash

#--CAMBIAR IP POR LA DE SERVER BACKEND--
IP_BACKEND=
#--CAMBIAR IP POR LA DE SERVER BACKEND--

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
rm -rf phpMyAdmin-latest-all-languages.tar.gz
wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz
tar -xzvf phpMyAdmin-latest-all-languages.tar.gz
rm -rf phpMyAdmin-latest-all-languages.tar.gz
mv phpMyAdmin*/ /var/www/html/phpmyadmin
mv /var/www/html/phpmyadmin/config.sample.inc.php config.inc.php
#NECESARIO EDITAR LA LINEA SERVERS HOST CON LA IP DEL BACK-END!!
apt install php-mbstring php-zip php-gd php-json php-curl -y
phpenmod mbstring
systemctl restart apache2

#Clonar repositorio de la aplicación propuesta
cd /var/www/html/
rm -rf iaw-practica-lamp
git clone https://github.com/josejuansanchez/iaw-practica-lamp
mv /var/www/html/iaw-practica-lamp/src/* /var/www/html/

#Clonar archivo de configuración config.php personal
cd /var/www/html/
rm config.php
rm -rf IAW-Practica-4
git clone https://github.com/ivanmp-lm/IAW-Practica-4.git
mv /var/www/html/IAW-Practica-4/src/config.php /var/www/html/
sed -i s#REPLACE_THIS_PATH#$IP_BACKEND# config.php

#Copiar archivo 000-default.conf
cp /var/www/html/IAW-Practica-4/src/000-default.conf /etc/apache2/sites-available/
systemctl restart apache2

#Eliminar el contenido que no sea útil
rm -rf /var/www/html/index.html
rm -rf /var/www/html/iaw-practica-lamp
rm -rf IAW-Practica-4
rm -rf phpMyAdmin-latest-all-languages.tar.gz

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
