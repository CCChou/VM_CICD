#!/bin/bash

# install git
sudo yum install -y git

# add user git for executing gitea
sudo useradd \
   --system \
   --shell /bin/bash \
   --comment 'Git Version Control' \
   --create-home \
   --home-dir /home/git \
   git
   
# create gitea structure
sudo mkdir -p /etc/gitea /var/lib/gitea/{custom,data,indexers,public,log}
sudo chown git:git /var/lib/gitea/{data,indexers,log}
sudo chmod 750 /var/lib/gitea/{data,indexers,log}
sudo chown root:git /etc/gitea
sudo chmod 770 /etc/gitea

# create database for gitea
mysql -u root -p1qaz@WSX << EOF
CREATE DATABASE gitea;
CREATE USER 'gitea'@'localhost' IDENTIFIED BY "1qaz@WSX";
GRANT ALL PRIVILEGES ON gitea.* TO 'gitea'@'localhost';
FLUSH PRIVILEGES;
EOF

# install gitea
sudo wget -O gitea https://dl.gitea.io/gitea/1.10.2/gitea-1.10.2-linux-amd64
sudo chmod +x gitea
sudo mv gitea /usr/local/bin/gitea

# register gitea as service
cat > /etc/systemd/system/gitea.service << EOF
[Unit]
Description=Gitea (Git with a cup of tea)
After=syslog.target
After=network.target
After=mariadb.service

[Service]
# Modify these two values and uncomment them if you have
# repos with lots of files and get an HTTP error 500 because
# of that
###
#LimitMEMLOCK=infinity
#LimitNOFILE=65535
RestartSec=2s
Type=simple
User=git
Group=git
WorkingDirectory=/var/lib/gitea/
ExecStart=/usr/local/bin/gitea web -c /etc/gitea/app.ini
Restart=always
Environment=USER=git HOME=/home/git GITEA_WORK_DIR=/var/lib/gitea
# If you want to bind Gitea to a port below 1024 uncomment
# the two values below
###
#CapabilityBoundingSet=CAP_NET_BIND_SERVICE
#AmbientCapabilities=CAP_NET_BIND_SERVICE

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl start gitea
sudo systemctl enable gitea
