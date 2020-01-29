#!/bin/bash

sudo yum install -y wget
sudo yum install -y java
wget -O ~/latest-unix.tar.gz https://download.sonatype.com/nexus/3/latest-unix.tar.gz
sudo tar zxvf latest-unix.tar.gz -C /opt

useradd nexus -s /sbin/nologin
sudo chown -R nexus:nexus sonatype-work/
sudo chown -R nexus:nexus nexus-3.20.1-01/

cat > /etc/systemd/system/nexus.service << EOF
[Unit]
Description=nexus service
After=network.target
  
[Service]
Type=forking
LimitNOFILE=65536
ExecStart=/opt/nexus-3.20.1-01/bin/nexus start
ExecStop=/opt/nexus-3.20.1-01/bin/nexus stop
User=nexus
Restart=on-abort
  
[Install]
WantedBy=multi-user.target
EOF

sudo systemctl start nexus
sudo systemctl enable nexus