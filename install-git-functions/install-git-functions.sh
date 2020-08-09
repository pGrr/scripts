#!/bin/bash

echo "Appending functions to ~/.bashrc file..."
cat ./git-functions.sh >> ~/.bashrc 

echo "Added content is: "
cat ~/.bashrc | tail -$(wc -l ./git-functions.sh)

echo "...Done! Reloading bash..."
exec bash
