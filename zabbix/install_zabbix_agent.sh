#!/usr/bin/bash

wget -q https://repo.zabbix.com/zabbix/6.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.0-4+ubuntu22.04_all.deb  

dpkg -i zabbix-release_6.0-4+ubuntu22.04_all.deb 

apt update

apt install -y -qq zabbix-agent 

echo "
Server=zabbix1
ServerActive=zabbix1
Hostname=z2
">> /etc/zabbix/zabbix_agentd.conf

systemctl restart zabbix-agent
systemctl enable zabbix-agent
