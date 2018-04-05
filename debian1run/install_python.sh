#Python 3.6一键安装脚本 for CentOS/Debian
#https://www.moerats.com/archives/507/
ln /usr/lib/x86_64-linux-gnu/libssl.so.1.0.0 /usr/local/libssl.so
ln /usr/lib/x86_64-linux-gnu/libcrypto.so.1.0.0 /usr/local/libcrypto.so
wget https://www.moerats.com/usr/shell/Python3/Debian_Python3.6.sh && sh Debian_Python3.6.sh
