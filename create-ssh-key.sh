#!/bin/bash

echo -n "Insert ssh key email: "
read email

echo -n "Insert ssh key password: "
read -s password

echo -n "Insert ssh key filename (leave empty if ~/.ssh/id_rsa is ok): "
read filename

echo "Creating new ssh key..."
ssh-keygen -t rsa -b 4096 -C "${email}" -P "${password}" -f "{filename:=~/.ssh/id_rsa}"

echo "Starting the ssh-agent in the background..."
eval "$(ssh-agent -s)"

echo "Adding SSH private key to the ssh-agent..."
ssh-add ~/.ssh/id_rsa

echo "Installing xclip..."
sudo apt-get install xclip

echo "Copying the SSH key to your clipboard..."
xclip -sel clip < ~/.ssh/id_rsa.pub

echo "...Done! ssh key has been generated and copied to clipboard."
