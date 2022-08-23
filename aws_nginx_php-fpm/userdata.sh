#!/usr/bin/env bash

sudo yum update -y

sudo yum install git -y

sudo amazon-linux-extras install nginx1 -y

sudo amazon-linux-extras enable php8.0 -y

sudo yum clean metadata -y

sudo yum install php php-cli php-mysqlnd php-pdo php-common php-fpm -y

sudo yum install php-gd php-mbstring php-xml php-dom php-intl php-simplexml php-soap php-opcache -y

sudo systemctl start nginx && sudo systemctl start php-fpm

cat > /etc/nginx/conf.d/ownspace.co.ua.conf << EOF
server {
    listen       80;
    server_name  ownspace.co.ua;

    access_log  /var/log/nginx/ownspace.access.log  main;
    error_log /var/log/nginx/ownspace.error.log error;

    location / {
        root   /usr/share/nginx/html/;
        index  index.php index.html index.htm;
        try_files $uri $uri/ = 404;
    }

    error_page  404              /404.html;

    # redirect server error pages to the static page /50x.html
    #
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }

    # pass the PHP scripts to FastCGI server listening socket
    #
    location ~ ^(.+\.php)(.*)$ {
        root /usr/share/nginx/html/;
        fastcgi_split_path_info ^(.+?\.php)(/.*)$;
        #try_files $uri =404;
        if (!-f $document_root$fastcgi_script_name) {
		      return 404;
	      }
        fastcgi_index  index.php;
        include        fastcgi_params;
	      fastcgi_param	PATH_INFO $fastcgi_path_info;
	      fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
	      fastcgi_pass   php-fpm;
    }

    # deny access to .htaccess files, if Apache's document root
    # concurs with nginx's one
    #
    location ~ /\.ht {
        deny  all;
    }
}
EOF

sudo systemctl restart nginx && sudo systemctl restart php-fpm
