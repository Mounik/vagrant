#!/usr/bin/bash

###############################################################
#  TITRE: 
#
#  AUTEUR:   Xavier
#  VERSION: 
#  CREATION:  
#  MODIFIE: 
#
#  DESCRIPTION: 
# 		https://github.com/apache/pulsar
###############################################################



# Variables ###################################################

PULSAR_VERSION=3.0.0
PULSAR_ID=$(hostname | sed "s/pulsar//g")

# Functions ###################################################



# Let's Go !! #################################################


installation_pulsar(){

swapoff -a
sed -i '/ swap / s/^/#/' /etc/fstab

groupadd --system pulsar
useradd -s /sbin/nologin --system -g pulsar pulsar
wget -q https://dlcdn.apache.org/pulsar/pulsar-${PULSAR_VERSION}/apache-pulsar-${PULSAR_VERSION}-bin.tar.gz 2>&1 >/dev/null
tar xzf apache-pulsar-${PULSAR_VERSION}-bin.tar.gz 2>&1 >/dev/null

mv apache-pulsar-${PULSAR_VERSION} /opt/pulsar
chown -R pulsar:pulsar /opt/pulsar

mkdir -p /data/{pulsar,bookeeper}

}

configuration_pulsar(){

sed -i s/"journalDirectory=.*"/"journalDirectory=\/data\/bookeeper\/journal"/g /opt/pulsar/conf/bookkeeper.conf
sed -i s/"advertisedAddress=.*"/"advertisedAddress=${HOSTNAME}"/g /opt/pulsar/conf/bookkeeper.conf
sed -i s/"ledgerDirectories=.*"/"ledgerDirectories=\/data\/bookeeper\/ledgers"/g /opt/pulsar/conf/bookkeeper.conf
sed -i s/"zkServers=.*"/"zkServers=pulsar1:2181,pulsar2:2181,pulsar3:2181"/g /opt/pulsar/conf/bookkeeper.conf


sed -i s/"zookeeperServers=.*"/"zookeeperServers=pulsar1:2181,pulsar2:2181,pulsar3:2181"/g /opt/pulsar/conf/broker.conf
sed -i s/"configurationStoreServers=.*"/"configurationStoreServers=pulsar1:2181,pulsar2:2181,pulsar3:2181"/g /opt/pulsar/conf/broker.conf
sed -i s/"advertisedAddress=.*"/"advertisedAddress=${HOSTNAME}"/g /opt/pulsar/conf/broker.conf
sed -i s/"clusterName=.*"/"clusterName=xavki"/g /opt/pulsar/conf/broker.conf

}

systemd_pulsar(){

echo "
[Unit]
Description=BookKeeper
After=network.target

[Service]
Environment=PULSAR_MEM=\"-Xms512m -Xmx512m -XX:MaxDirectMemorySize=1g\"
ExecStart=/opt/pulsar/bin/pulsar bookie
WorkingDirectory=/opt/pulsar
RestartSec=1s
Restart=on-failure
Type=simple

[Install]
WantedBy=multi-user.target
" > /etc/systemd/system/pulsar-bookeeper.service

echo "
[Unit]
Description=Pulsar Broker
After=network.target

[Service]
Environment=PULSAR_MEM=\"-Xms512m -Xmx512m -XX:MaxDirectMemorySize=1g\"
ExecStart=/opt/pulsar/bin/pulsar broker
WorkingDirectory=/opt/pulsar
RestartSec=1s
Restart=on-failure
Type=simple

[Install]
WantedBy=multi-user.target
" > /etc/systemd/system/pulsar-broker.service

echo "
[Unit]
Description=Pulsar Proxy
After=network.target

[Service]
ExecStart=/opt/pulsar/bin/pulsar proxy
WorkingDirectory=/opt/pulsar
RestartSec=1s
Restart=on-failure
Type=simple

[Install]
WantedBy=multi-user.target
" > /etc/systemd/system/pulsar-proxy.service

systemctl start pulsar-bookeeper
systemctl enable pulsar-bookeeper
systemctl start pulsar-broker
systemctl enable pulsar-broker

}

# Let's Go !! #################################################

installation_pulsar
configuration_pulsar
systemd_pulsar

if [[ $PULSAR_ID == "3" ]];then
	sleep 15s
  /vagrant/initialize.sh
  /opt/pulsar/bin/pulsar-admin tenants create xtenant
  /opt/pulsar/bin/pulsar-admin namespaces create xtenant/xns
  /opt/pulsar/bin/pulsar-admin topics create-partitioned-topic xtenant/xns/xavki-topic -p 6
fi
