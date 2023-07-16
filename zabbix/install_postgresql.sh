#!/usr/bin/bash


#apt install -qq -y postgresql 2>&1 >/dev/null
apt install -y postgresql
pg_ctlcluster 14 main start

sudo -u postgres psql -c "create database zabbix;"
sudo -u postgres psql -c "create user zabbix with password 'password';"
sudo -u postgres psql -c "grant ALL privileges on database zabbix to zabbix;"

echo "listen_addresses = '*'" >> /etc/postgresql/14/main/postgresql.conf && systemctl restart postgresql
echo "host    zabbix     all             192.168.0.1/16            md5" >> /etc/postgresql/14/main/pg_hba.conf && systemctl reload postgresql
