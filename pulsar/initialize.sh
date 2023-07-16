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



# Functions ###################################################



# Let's Go !! #################################################

/opt/pulsar/bin/pulsar initialize-cluster-metadata \
  --cluster xavki \
  --zookeeper pulsar2:2181 \
  --configuration-store pulsar1:2181 \
  --web-service-url http://pulsar1:8080,pulsar2:8080,pulsar3:8080 \
  --web-service-url-tls https://pulsar1:8443,pulsar2:8443,pulsar3:8443 \
  --broker-service-url pulsar://pulsar1:6650,pulsar2:6650,pulsar3:6650 \
  --broker-service-url-tls pulsar+ssl://pulsar1:6651,pulsar2:6651,pulsar3:6651
