#!/bin/bash

# 检查是否以root用户运行脚本
if [ "$(id -u)" != "0" ]; then
    echo "此脚本需要以root用户权限运行。"
    echo "请尝试使用 'sudo -i' 命令切换到root用户，然后再次运行此脚本。"
    exit 1
fi
echo ''
echo '由于zkverify节点只能在普通用户环境下按照，所以需要设置普通用户信息'
echo ''
# read -p "请输入你的普通用户名: " username
read -p "请输入你的普通用户名登录密码: " password
username=zkverify1
# password=Aa112211.
# 创建新用户
sudo adduser $username --gecos "" --disabled-password

# 设置用户密码
echo "$username:$password" | sudo chpasswd

echo "User $username created with the password provided."

# 向 sudoers 文件添加配置
echo "$username   ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

echo "已为用户 $username 添加 sudo ，普通用户sudo也无需密码！"

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

##由于在用户环境下安装docker，会导致无权限运行，所以在安装完docker后，将用户加入组，再进行环境切换
echo ''
echo '已切换为普通用户环境'
su - $username

