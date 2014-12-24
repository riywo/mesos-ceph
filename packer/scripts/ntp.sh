#!/bin/bash
sudo apt-get update
sudo apt-get install -y ntp

sudo sed -i -e 's/^\(server .*\)$/# \1/g' /etc/ntp.conf

echo server 0.amazon.pool.ntp.org iburst | sudo tee -a /etc/ntp.conf
echo server 1.amazon.pool.ntp.org iburst | sudo tee -a /etc/ntp.conf
echo server 2.amazon.pool.ntp.org iburst | sudo tee -a /etc/ntp.conf
echo server 3.amazon.pool.ntp.org iburst | sudo tee -a /etc/ntp.conf

sudo service ntp restart
