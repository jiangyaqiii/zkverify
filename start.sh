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
sudo apt install -y git
# 检查 Docker 是否已安装
if ! command -v docker &> /dev/null
  then
    # 如果 Docker 未安装，则进行安装
    echo "未检测到 Docker，正在安装..."
    sudo apt-get install ca-certificates curl gnupg lsb-release

    # 添加 Docker 官方 GPG 密钥
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    # 设置 Docker 仓库
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    # 授权 Docker 文件
    sudo chmod a+r /etc/apt/keyrings/docker.gpg
    sudo apt-get update

    # 安装 Docker 最新版本
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
else
    echo "Docker 已安装。"
fi

# 安装 Docker compose 最新版本
DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
mkdir -p $DOCKER_CONFIG/cli-plugins
curl -SL https://github.com/docker/compose/releases/download/v2.5.0/docker-compose-linux-x86_64 -o $DOCKER_CONFIG/cli-plugins/docker-compose
chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose
docker compose version

# 验证 Docker Engine 安装是否成功
sudo docker run hello-world
# 应该能看到 hello-world 程序的输出
sudo apt install jq -y
sudo jq --version

#zkverify无需sudo运行docker
sudo usermod -aG docker zkverify

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
cd
sudo rm -f start.sh







