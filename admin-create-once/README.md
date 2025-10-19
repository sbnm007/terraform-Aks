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