#!/bin/bash

echo "Appending functions to ~/.bashrc file..."
cat ./functions.sh >> ~/.bashrc 

echo "Added content is: "
cat ~/.bashrc | tail -$(wc -l ./functions.sh)

source ~/.bashrc

echo "...Done!"
