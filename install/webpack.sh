#!/bin/bash

echo -e "\n\nUPDATING THE APT-GET PACKAGE INDEX...\n\n"
sudo apt-get update

echo -e "\n\nINSTALLING WEBPACK...\n\n"
sudo npm install -y -g webpack
echo -e "\n\nSuccessfully installed version $(webpack -v)\n\n"

echo -e "\n\nINSTALLING WEBPACK-CLI...\n\n"
sudo npm install -y -g webpack-cli
echo -e "\n\nSuccessfully installed version $(webpack-cli -v)\n\n"


