# zkverify

===============创建普通用户zkverify脚本，zk安装脚本需要普通用户运行================
export password='xxx'

wget -O adduser.sh https://raw.githubusercontent.com/jiangyaqiii/zkverify/web/adduser.sh && chmod +x adduser.sh && ./adduser.sh

===========================================

===============以zkverify账户登录，启动zkverify脚本================

wget -O start.sh https://raw.githubusercontent.com/jiangyaqiii/zkverify/web/start.sh && chmod +x start.sh && ./start.sh

===========================================

===============获取Babe和ImOnline值脚本================

wget -O get_Babe_ImOnline.sh https://raw.githubusercontent.com/jiangyaqiii/zkverify/web/get_Babe_ImOnline.sh && chmod +x get_Babe_ImOnline.sh && ./get_Babe_ImOnline.sh

===========================================

===============获取Grandpa值脚本================

wget -O get_Grandpa.sh https://raw.githubusercontent.com/jiangyaqiii/zkverify/web/get_Grandpa.sh && chmod +x get_Grandpa.sh && ./get_Grandpa.sh

===========================================

===============获取验证者节点助记词脚本================

wget -O get_secret_phrase.sh https://raw.githubusercontent.com/jiangyaqiii/zkverify/web/get_secret_phrase.sh && chmod +x get_secret_phrase.sh && ./get_secret_phrase.sh

===========================================

