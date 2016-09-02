#!/bin/bash
sudo apt-get update -y
sudo apt-get install build-essential libpcre3 git libpcre3-dev libssl-dev software-properties-common -y
iptables -I INPUT -p tcp --dport 8081 -j ACCEPT
iptables -I INPUT -p tcp --dport 1935 -j ACCEPT
mkdir /var/log/nginx-rtmp/
touch /var/log/nginx-rtmp/error.log
sudo mkdir ~/working
cd ~/working
wget http://nginx.org/download/nginx-1.11.3.tar.gz
git clone https://github.com/arut/nginx-rtmp-module.git
sudo /usr/sbin/update-rc.d -f nginx-rtmp defaults
git clone https://github.com/beginho/Nginx-Media-Server.git
cp ~/working/Nginx-Media-Server/conf/nginx.txt /etc/init.d/nginx-rtmp
sudo chmod +x /etc/init.d/nginx-rtmp
sudo /usr/sbin/update-rc.d -f nginx-rtmp defaults
tar xf nginx-1.11.3.tar.gz
cd ~/working/nginx-1.11.3
./configure --with-http_ssl_module --add-module=../nginx-rtmp-module --prefix=/opt/nginx
sudo make && make install
mkdir /opt/nginx/html/live/
mkdir /opt/nginx/html/live/hls/
touch /opt/nginx/conf/nginx.conf
cp ~/working/Nginx-Media-Server/conf/nginx.conf /opt/nginx/conf/nginx.conf
ip=$(curl -s checkip.dyndns.org | sed -e 's/.*Current IP Address: //' -e 's/<.*$//' )
sed -i -- 's/replaceip/'"$ip"'/g' /opt/nginx/conf/nginx.conf
rm -f /opt/nginx/conf/nginx.conf.default
sudo rm -rf ~/working
echo Finished!
echo "Start nginx-rtmp with: service nginx-rtmp start"
