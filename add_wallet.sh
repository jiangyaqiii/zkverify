#安装钱包所需环境
curl -sSL https://raw.githubusercontent.com/allora-network/allora-chain/main/install.sh | bash -s -- v0.0.7
sudo apt-get update  -y
sudo apt-get install -y make gcc
rm -rf /usr/local/go
curl -OL <https://go.dev/dl/go1.21.linux-amd64.tar.gz>  
sudo tar -C /usr/local -xvf go1.21.linux-amd64.tar.gz
export PATH=$PATH:$(go env GOPATH)/bin

#安装allora钱包
git clone -b <latest-release-tag> https://github.com/allora-network/allora-chain.git
cd allora-chain && make all
allorad version
#创建钱包

allorad keys add wallet
