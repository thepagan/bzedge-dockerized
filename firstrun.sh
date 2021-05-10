#!/bin/bash
sudo touch /etc/systemd/system/bzedged.service
sudo chown bzedge:bzedge /etc/systemd/system/bzedged.service
ls -al /etc/systemd/system
sudo cat << EOF > /etc/systemd/system/bzedged.service
[Unit]
Description=BZEdged service
After=network.target
[Service]
Type=forking
User=bzedge
Group=bzedge
WorkingDirectory=/home/bzedge/.bzedge
ExecStart=/home/bzedge/bzedge/src/bzedged -datadir=/home/bzedge/.bzedge/ -conf=/home/bzedge/.bzedge/bzedge.conf -daemon
ExecStop=/home/bzedge/bzedge/src/bzedge-cli stop
Restart=always
RestartSec=3
PrivateTmp=true
TimeoutStopSec=60s
TimeoutStartSec=10s
StartLimitInterval=120s
StartLimitBurst=5
[Install]
WantedBy=multi-user.target
EOF
sudo chown root:root /etc/systemd/system/bzedged.service
sudo systemctl daemon-reload
sudo systemctl enable bzedged.service > /dev/null 2>&1
sudo systemctl start bzedged.service
sleep 4
RPCUSER=$(pwgen -1 8 -n)
PASSWORD=$(pwgen -1 20 -n)
echo "rpcport=1980" >> ~/.bzedge/bzedge.conf
echo 'rpcuser=$RPCUSER >> ~/.bzedge/bzedge.conf
echo 'rpcpassword=$PASSWORD' >> ~/.bzedge/bzedge.conf
