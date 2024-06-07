#!/bin/bash

# 设置要检查的用户名
EXPECTED_USER="zkverify"

# 获取当前实际运行脚本的用户名
CURRENT_USER=$(whoami)

# 检查当前用户是否与期望用户相同
if [ "$CURRENT_USER" == "$EXPECTED_USER" ]; then
    echo "当前用户与期望用户相同：$EXPECTED_USER"
else
    echo "当前用户为：$CURRENT_USER，而非期望用户：$EXPECTED_USER"
fi

#安装所需软件
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl software-properties-commoncurl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io
sudo systemctl start docker
sudo systemctl enable docker
sudo docker --version
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
sudo docker-compose --version
sudo apt install jq -y
sudo jq --version

#zkverify无需sudo运行docker
sudo usermod -aG docker zkverify

sudo git clone https://github.com/HorizenLabs/compose-zkverify-simplified.git
cd compose-zkverify-simplified
#启动rpc需要选择参数
echo ''
echo '启动rpc'
sudo scripts/init.sh
sudo docker compose -f /home/zkverify/compose-zkverify-simplified/deployments/rpc-node/testnet/docker-compose.yml up -d
sudo docker container ls

#启动boot节点需要选择参数
echo ''
echo '启动boot节点'
sudo scripts/init.sh
sudo docker compose -f /home/zkverify/compose-zkverify-simplified/deployments/boot-node/testnet/docker-compose.yml up -d
sudo docker container ls

#启动validator节点需要选择参数
echo ''
echo '启动validator节点'
sudo scripts/init.sh
sudo docker compose -f /home/zkverify/compose-zkverify-simplified/deployments/validator-node/testnet/docker-compose.yml up -d
sudo docker container ls
cd
sudo rm -f start.sh







