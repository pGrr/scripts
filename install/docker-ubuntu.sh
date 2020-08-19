#!/bin/bash

echo -e "\nUninstalling old versions...\n"
sudo apt-get remove docker docker-engine docker.io containerd runc

echo -e "\nUpdating the apt package index...\n"
sudo apt-get update
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

echo -e "\nAdding Docker’s official GPG key...\n"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

echo -e "\nChecking fingerprint...\n"
fingerprint=$(apt-key fingerprint 0EBFCD88 2>/dev/null | sed -n 2p | sed  -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'
)
if [ "${fingerprint}" == "9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88" ] 
then
    echo -e "...fingerprint OK.\n"
else
    echo -e "...wrong fingerprint! Exiting...\n"
    exit 1
fi

echo -e "\nSetting up the stable repository...\n"
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

echo -e "\nUpdating the apt package index...\n"
sudo apt-get update

echo -e "\nInstalling the latest version of Docker Engine and containerd...\n"
sudo apt-get install docker-ce docker-ce-cli containerd.io

echo -e "\nVerifying the correct installation by running the hello-world image...\n"
sudo docker run hello-world

echo -e "\nCreating the docker group...\n"
sudo groupadd docker

echo -e "\nAdding $USER to the docker group...\n"
sudo usermod -aG docker $USER

echo -e "\nRe-evaluating group memberships...\n"
su - $USER -c " \
echo -e \"\nVerifying the correct installation by running the hello-world image without sudo...\n\"; \
docker run hello-world; \
echo \"...Done!\"; \
" 
