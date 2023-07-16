#!/bin/bash

## install zabbix

IP=$(hostname -I | awk '{print $2}')
echo "START - install zabbix "$IP



wget https://repo.zabbix.com/zabbix/6.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.0-4+ubuntu22.04_all.deb
sudo dpkg -i zabbix-release_6.0-4+ubuntu22.04_all.deb
sudo apt update -qq 2>&1 >/dev/null


apt install -y zabbix-server-pgsql zabbix-frontend-php php8.1-pgsql zabbix-nginx-conf zabbix-sql-scripts zabbix-agent postgresql-client

zcat /usr/share/zabbix-sql-scripts/postgresql/server.sql.gz | PGPASSWORD="password" psql -h zpg1 -U zabbix zabbix
sed -i s/"#.*server_name.*"/"        server_name zabbix.xavki; "/g /etc/zabbix/nginx.conf
echo "DBPassword=password" >> /etc/zabbix/zabbix_server.conf
echo "DBHost=zpg1" >> /etc/zabbix/zabbix_server.conf
systemctl restart zabbix-server zabbix-agent nginx php8.1-fpm
systemctl enable zabbix-server zabbix-agent nginx php8.1-fpm
