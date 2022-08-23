#!/usr/bin/env bash

sudo yum update -y

sudo yum install git -y

sudo amazon-linux-extras install nginx1 -y

sudo amazon-linux-extras enable php8.0 -y

sudo yum clean metadata -y

sudo yum install php php-cli php-mysqlnd php-pdo php-common php-fpm -y

sudo yum install php-gd php-mbstring php-xml php-dom php-intl php-simplexml php-soap php-opcache -y

sudo systemctl start nginx && sudo systemctl start php-fpm

sudo systemctl restart nginx && sudo systemctl restart php-fpm
