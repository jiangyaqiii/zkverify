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
    su - $EXPECTED_USER
    echo '自动切换为期望用户'
fi

git clone https://github.com/HorizenLabs/compose-zkverify-simplified.git
cd compose-zkverify-simplified
#启动rpc需要选择参数
echo ''
echo '启动rpc'
echo -e "1\n1\n2\n2\n1" | scripts/init.sh
docker compose -f /home/zkverify/compose-zkverify-simplified/deployments/rpc-node/testnet/docker-compose.yml up -d
docker container ls

#启动boot节点需要选择参数
echo ''
echo '启动boot节点'
echo -e "3\n1\n2\n2" | scripts/init.sh
docker compose -f /home/zkverify/compose-zkverify-simplified/deployments/boot-node/testnet/docker-compose.yml up -d
docker container ls

#启动validator节点需要选择参数
echo ''
echo '启动validator节点'
echo -e "2\n1\n2\n2\2" | scripts/init.sh
docker compose -f /home/zkverify/compose-zkverify-simplified/deployments/validator-node/testnet/docker-compose.yml up -d
docker container ls
cd
sudo rm -f start.sh







