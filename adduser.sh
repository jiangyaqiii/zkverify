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
read -p "请输入你的普通用户名: " username
read -p "请输入你的普通用户名登录密码: " password
echo ''
echo '普通用户设置完毕，请退出'
# username=zkverify
# password=Aa112211.
# 创建新用户
sudo adduser $username --gecos "" --disabled-password

# 设置用户密码
echo "$username:$password" | sudo chpasswd

echo "User $username created with the password provided."

# 向 sudoers 文件添加配置
echo "$username   ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

echo "已为用户 $username 添加 sudo 无需密码权限！"
