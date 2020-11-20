#!/bin/bash

#Mostrar en pantalla los comandos que se van ejecutando
set -x

#Actualizar repositorios
apt update

#Instalar apache2
apt install apache2 -y

#Clonar archivos necesarios para la configuración
rm -rf IAW-Practica-4
git clone https://github.com/ivanmp-lm/IAW-Practica-4.git

#Copiar archivo 000-default.conf del repositorio clonado
cp /IAW-Practica-4/src/000-default.conf /etc/apache2/sites-available/
systemctl restart apache2

#Eliminar archivos sobrantes
rm -rf IAW-Practica-4

#Activar los módulos necesarios de Apache2
a2enmod proxy
a2enmod proxy_http
a2enmod proxy_ajp
a2enmod rewrite
a2enmod deflate
a2enmod headers
a2enmod proxy_balancer
a2enmod proxy_connect
a2enmod proxy_html
a2enmod lbmethod_byrequests

#Reiniciar el servicio de Apache2
sudo systemctl restart apache2
