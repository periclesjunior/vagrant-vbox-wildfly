#!/bin/bash

sudo useradd -m -d /opt/wildfly -s /bin/bash -U -u 2000 wildfly

sudo cp -ap /opt/vagrant/data/wildfly-10.1.0.Final/* /opt/wildfly/

sudo chown -R wildfly.wildfly /opt/wildfly

sudo mkdir /opt/java

sudo cp -apR /opt/vagrant/data/jre1.8.0_251 /opt/java/

sudo sed -i "s/#JAVA_HOME=\"\/opt\/java\/jdk\"/JAVA_HOME=\"\/opt\/java\/jre1.8.0_251\"/;\
     s/Xms64m/Xms512m/;\
     s/Xmx512m/Xmx1024m/;\
     s/MetaspaceSize=96M/MetaspaceSize=512M/;\
     s/MaxMetaspaceSize=256m/MaxMetaspaceSize=1024m/;" \
     /opt/wildfly/bin/standalone.conf

sudo mkdir /var/log/wildfly

sudo chown -R wildfly.wildfly /var/log/wildfly

sudo echo -e "\n# Configure default logs dir\nJAVA_OPTS=\"\$JAVA_OPTS -Djboss.server.log.dir=/var/log/wildfly/\"" >> /opt/wildfly/bin/standalone.conf 

sudo mkdir /etc/wildfly

sudo cp /opt/wildfly/docs/contrib/scripts/systemd/wildfly.conf /etc/wildfly/

sudo sed -i 's/0.0.0.0/192.168.122.253/g' /etc/wildfly/wildfly.conf

sudo cp /opt/wildfly/docs/contrib/scripts/systemd/launch.sh /opt/wildfly/bin/

sudo cp /opt/wildfly/docs/contrib/scripts/systemd/wildfly.service /etc/systemd/system/

sudo systemctl daemon-reload

sudo systemctl enable wildfly.service

sudo systemctl start wildfly.service

cp -ap /opt/vagrant/data/deploy/* /opt/wildfly/standalone/deployments/
