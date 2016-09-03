#!/bin/bash
echo "Centos Builder..."
yum -y install gcc gcc-c++ make zlib-devel pcre-devel openssl-devel
iptables -I INPUT -p tcp --dport 8081 -j ACCEPT
iptables -I INPUT -p tcp --dport 1935 -j ACCEPT
useradd -r nginx
sudo mkdir ~/working
cd ~/working
wget http://nginx.org/download/nginx-1.11.3.tar.gz
git clone https://github.com/arut/nginx-rtmp-module.git
git clone https://github.com/beginho/nrs.git
cp ~/working/nrs/conf/nginx_centos.txt /etc/init.d/nginx-rtmp
sudo chmod +x /etc/init.d/nginx-rtmp
chkconfig --add nginx-rtmp
chkconfig --level 345 nginx-rtmp on
tar xf nginx-1.11.3.tar.gz
cd ~/working/nginx-1.11.3
./configure --with-http_ssl_module --add-module=../nginx-rtmp-module --prefix=/opt/nginx
sudo make && make install
mkdir /opt/nginx/html/live/
mkdir /opt/nginx/html/live/hls/
cp ~/working/nrs/conf/nginx.conf /opt/nginx/conf/nginx.conf
cp ~/working/nrs/conf/stat.xml /opt/nginx/html/stat.xsl
rm -f /opt/nginx/conf/nginx.conf.default
sudo rm -rf ~/working
echo Finished!
echo "Start nginx-rtmp with: service nginx-rtmp start"
