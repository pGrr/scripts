#!/bin/bash

wget https://download.virtualbox.org/virtualbox/6.1.14/virtualbox-6.1_6.1.14-140239~Ubuntu~eoan_amd64.deb
sudo dpkg -i ./virtualbox-6.1_6.1.14-140239~Ubuntu~eoan_amd64.deb
sudo apt-get -f install
rm virtualbox-6.1_6.1.14-140239~Ubuntu~eoan_amd64.deb

