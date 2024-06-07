#!/bin/bash

# 检查是否以root用户运行脚本
if [ "$(id -u)" != "0" ]; then
    echo "此脚本需要以root用户权限运行。"
    echo "请尝试使用 'sudo -i' 命令切换到root用户，然后再次运行此脚本。"
    exit 1
fi

username=zkverify
password=Aa112211.
# 创建新用户
sudo adduser $username --gecos "" --disabled-password

# 设置用户密码
echo "$username:$password" | sudo chpasswd

echo "User $username created with the password provided."

#安装所需软件
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl software-properties-commoncurl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io
sudo systemctl start docker
sudo systemctl enable docker
docker --version
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
docker-compose --version
sudo apt install jq -y
jq --version

#zkverify无需sudo运行docker
sudo usermod -aG docker zkverify

#切换到普通用户下
su - zkverify <<EOF

git clone https://github.com/HorizenLabs/compose-zkverify-simplified.git
cd compose-zkverify-simplified
#启动rpc需要选择参数
echo ''
echo '启动rpc'
scripts/init.sh
docker compose -f /home/zkverify/compose-zkverify-simplified/deployments/rpc-node/testnet/docker-compose.yml up -d
docker container ls

#启动boot节点需要选择参数
echo ''
echo '启动boot节点'
scripts/init.sh
docker compose -f /home/zkverify/compose-zkverify-simplified/deployments/boot-node/testnet/docker-compose.yml up -d
docker container ls

#启动validator节点需要选择参数
echo ''
echo '启动validator节点'
scripts/init.sh
docker compose -f /home/zkverify/compose-zkverify-simplified/deployments/validator-node/testnet/docker-compose.yml up -d
docker container ls
rm -f start.sh







