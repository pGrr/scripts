#!/bin/bash

sudo apt-get install git

echo -n "Username: "
read username

echo -n "Password: "
read -s password

echo "Setting up username..."
git config --global user.name "John Doe"

echo "Setting up password..."
$ git config --global user.email johndoe@example.com

echo "...done!"