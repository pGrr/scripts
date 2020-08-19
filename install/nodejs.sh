#!/bin/bash

echo -e "\n\nUPDATING THE APT-GET PACKAGE INDEX...\n\n"
sudo apt-get update

echo -e "\n\nINSTALLING CURL...\n\n"
sudo apt-get install -y curl

echo -e "\n\nINSTALLING NODEJS...\n\n"
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt-get install -y nodejs
echo -e "\n\nSuccessfully installed version $(node -v)\n\n"

