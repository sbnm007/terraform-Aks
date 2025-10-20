# Steps to create admin

Configure ssh key
ssh-keygen -t rsa -b 4096 -f ~/.ssh/admin_rsa

check if it exisits
ls -la ~/.ssh/admin_rsa.pub


get your public ip
curl -s https://ipinfo.io/ip 


1) Create VM on azure with public ip

2) Allow ssh rule for my ip

3) Configure Self hosted runner with steps from Github by sshing into your instance


# Configured Self hosted runner agent on server
use this in github workflow
runs-on: self-hosted

#configuring admin server
install az
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

az --version

install terraform
# Install Terraform permanently
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform


#Install kubectl
# SSH to your admin server
ssh azureuser@$(cd admin-create-once && terraform output -raw public_ip)

# On admin server - install kubectl
sudo apt-get update

# Install packages needed for apt repository
sudo apt-get install -y apt-transport-https ca-certificates curl gpg

# Download the public signing key for the Kubernetes package repositories
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# Add the Kubernetes apt repository
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Update apt package index and install kubectl
sudo apt-get update
sudo apt-get install -y kubectl

# Verify installation
kubectl version --client




#Issue
I was directly deploying istio images but faced image pull error probably because of rate limitting to my azure vm


Solution to build and deploy and test custom images - Docker was down and came up



