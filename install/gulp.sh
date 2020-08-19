#!/bin/bash

echo -e "\n\nUPDATING THE APT-GET PACKAGE INDEX...\n\n"
sudo apt-get update

echo -e "\n\nINSTALLING GULP-CLI...\n\n"
sudo npm install -y -g gulp-cli
gulp -v
 
