#!/bin/bash 

wget https://releases.hashicorp.com/vagrant/2.2.10/vagrant_2.2.10_x86_64.deb
sudo dpkg -i vagrant_2.2.10_x86_64.deb
sudo apt-get -f install
vagrant -v
rm vagrant_2.2.10_x86_64.deb

