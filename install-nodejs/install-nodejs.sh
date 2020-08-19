#!/bin/bash

sudo apt-get update
sudo apt-get install -y curl
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt-get install -y nodejs

echo -e "\n\nSuccessfully installed version $(node -v)\n\n"

