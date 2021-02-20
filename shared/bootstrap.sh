#!/bin/bash

sudo groupadd -r wildfly

sudo useradd -r -g wildfly -m -d /opt/wildfly -s /sbin/nologin wildfly

sudo mkdir /opt/java

sudo mkdir /var/log/wildfly

sudo cp -R /opt/vagrant/data/wildfly-10.1.0.Final/* /opt/wildfly/

sudo cp -R /opt/vagrant/data/jre1.8.0_251 /opt/java/

sudo cp -R /opt/vagrant/data/deploy/*  /opt/wildfly/standalone/deployments/

sudo cp /opt/wildfly/docs/contrib/scripts/systemd/launch.sh /opt/wildfly/bin/

sudo chown -R wildfly.wildfly /opt/{java,wildfly}

sudo chown wildfly.wildfly /var/log/wildfly

sudo sed -i "s/#JAVA_HOME=\"\/opt\/java\/jdk\"/JAVA_HOME=\"\/opt\/java\/jre1.8.0_251\"/;\
     s/Xms64m/Xms512m/;\
     s/Xmx512m/Xmx1024m/;\
     s/MetaspaceSize=96M/MetaspaceSize=512M/;\
     s/MaxMetaspaceSize=256m/MaxMetaspaceSize=1024m/;" \
     /opt/wildfly/bin/standalone.conf

sudo echo -e "\n# Configure default logs dir\nJAVA_OPTS=\"\$JAVA_OPTS -Djboss.server.log.dir=/var/log/wildfly/\"" >> /opt/wildfly/bin/standalone.conf

sudo mkdir /etc/wildfly

sudo cp /opt/wildfly/docs/contrib/scripts/systemd/wildfly.conf /etc/wildfly/

sudo sed -i 's/0.0.0.0/192.168.122.253/g' /etc/wildfly/wildfly.conf

sudo cp /opt/wildfly/docs/contrib/scripts/systemd/wildfly.service /etc/systemd/system/

sudo sed -i 's/=wildfly/=root/g' /etc/systemd/system/wildfly.service

sudo systemctl daemon-reload

sudo systemctl enable wildfly.service

sudo systemctl start wildfly.service
