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
###############################################################



# Variables ###################################################

ZOO_ID=$(hostname | sed "s/pulsar//g")

if [[ ${ZOO_ID} == "1" ]];then ZOO1="server.1=0.0.0.0:2888:3888"; else ZOO1="server.1=pulsar1:2888:3888";fi
if [[ ${ZOO_ID} == "2" ]];then ZOO2="server.2=0.0.0.0:2888:3888"; else ZOO2="server.2=pulsar2:2888:3888";fi
if [[ ${ZOO_ID} == "3" ]];then ZOO3="server.3=0.0.0.0:2888:3888"; else ZOO3="server.3=pulsar3:2888:3888";fi

# Functions ###################################################

install_zookeeper(){

#apt update && apt install -y -qq zookeeper netcat
addgroup zookeeper
useradd -s /sbin/nologin --system -g zookeeper zookeeper
wget -q https://dlcdn.apache.org/zookeeper/zookeeper-3.8.1/apache-zookeeper-3.8.1-bin.tar.gz
tar xzf apache-zookeeper-3.8.1-bin.tar.gz
mv apache-zookeeper-3.8.1-bin/ /opt/zookeeper
mkdir -p /data/zookeeper
chown -R zookeeper:zookeeper /opt/zookeeper
chown -R zookeeper:zookeeper /data/zookeeper/
}

config_zookeeper(){

echo "
autopurge.purgeInterval=1
autopurge.snapRetainCount=5
# To avoid seeks ZooKeeper allocates space in the transaction log file in blocks of preAllocSize kilobytes.
# The default block size is 64M. One reason for changing the size of the blocks is to reduce the block size
# if snapshots are taken more often. (Also, see snapCount).
preAllocSize=65536
# ZooKeeper logs transactions to a transaction log. After snapCount transactions are written to a log file a
# snapshot is started and a new transaction log file is started. The default snapCount is 10,000.
snapCount=10000
tickTime=2000
dataDir=/data/zookeeper
clientPort=2181
admin.serverPort=8090
initLimit=5
syncLimit=2
# define servers ip and internal ports to zookeeper
${ZOO1}
${ZOO2}
${ZOO3}
" >> /opt/zookeeper/conf/zoo.cfg

echo ${ZOO_ID} > /data/zookeeper/myid

}

systemd_zookeeper(){

echo "Create a service systemd for Zookeeper"
echo '[Unit]
Description=Apache Zookeeper Server
Documentation=http://kafka.apache.org/documentation.html
Requires=network.target
After=network.target zookeeper.service

[Service]
Environment=ZK_SERVER_HEAP=256
Type=forking
User=zookeeper
Group=zookeeper

ExecStart=/opt/zookeeper/bin/zkServer.sh start /opt/zookeeper/conf/zoo.cfg
ExecStop=/opt/zookeeper/bin/zkServer.sh stop /opt/zookeeper/conf/zoo.cfg
ExecReload=/opt/zookeeper/bin/zkServer.sh restart /opt/zookeeper/conf/zoo.cfg
Restart=on-abnormal

[Install]
WantedBy=multi-user.target' > /etc/systemd/system/zookeeper.service

}


start_zookeeper(){

echo "Restart & enable zookeeper"

systemctl enable zookeeper
systemctl start zookeeper

}

## Run #########################################################

install_zookeeper
config_zookeeper
systemd_zookeeper
start_zookeeper

