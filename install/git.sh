#!/bin/bash

sudo apt-get install git

echo -n "Username: "
read username

echo -n "Email: "
read -s email

echo "Setting up username..."
git config --global user.name "${username}"

echo "Setting up email..."
git config --global user.email "${email}"

echo "...done!"
