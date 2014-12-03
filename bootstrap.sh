#Upgrade the Ubuntu repository to use Old packages
#sed -i -e 's/us.archive.ubuntu.com\|security.ubuntu.com/old-releases.ubuntu.com/g' /etc/apt/sources.list 

#Basics
apt-get update
apt-get install -y chkconfig
apt-get install -y vim
apt-get install -y unzip 
apt-get install -y make 

#Apache com https
apt-get install -y apache2
apt-get install -y php5 php5-dev git
service apache2 stop
cp /etc/apache2/mods-available/proxy.* /etc/apache2/mods-enabled/
cp /etc/apache2/mods-available/proxy_http.* /etc/apache2/mods-enabled/
echo "ProxyPass /sample/res http://localhost:8080/sample/res" >> /etc/apache2/httpd.conf
echo "ProxyPass /cas http://localhost:8080/cas" >> /etc/apache2/httpd.conf
echo "ProxyPassReverse /sample/res http://localhost:8080/sample/res" >> /etc/apache2/httpd.conf
echo "ProxyPassReverse /cas http://localhost:8080/cas" >> /etc/apache2/httpd.conf
service apache2 start
a2enmod ssl
service apache2 restart
mkdir /etc/apache2/ssl
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/apache2/ssl/apache.key -out /etc/apache2/ssl/apache.crt
openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=BR/ST=SC/L=Florianopolis/O=Softplan/CN=pocng.softplan.com.br" -keyout /etc/apache2/ssl/apache.key  -out /etc/apache2/ssl/apache.crt
sed -i 's/\/etc\/ssl\/certs\/ssl-cert-snakeoil.pem/\/etc\/apache2\/ssl\/apache.crt/g' /etc/apache2/sites-available/default-ssl
sed -i 's/\/etc\/ssl\/private\/ssl-cert-snakeoil.key/\/etc\/apache2\/ssl\/apache.key/g' /etc/apache2/sites-available/default-ssl
a2ensite default-ssl
sed -i '2iJkMountCopy On' /etc/apache2/sites-enabled/000-default
sed -i '2iJkMountCopy On' /etc/apache2/sites-enabled/default-ssl
service apache2 restart

#OpenJDK 7
apt-get install -y openjdk-7-jdk
mkdir /usr/java
ln -s /usr/lib/jvm/java-7-openjdk-i386 /usr/java/default

#Env variables
echo "export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-i386" >> ~/.bash_profile
echo "export CLASSPATH=.:$JAVA_HOME/lib/tools.jar:$JAVA_HOME/lib/dt.jar" >> ~/.bash_profile
echo "export PATH=$JAVA_HOME/bin:$PATH" >> ~/.bash_profile
echo "export CATALINA_HOME=/opt/servers/apache-tomcat-8.0.14" >> ~/.bash_profile
echo "sudo service mongod start" >> ~/.bashrc

#Tomcat
wget http://archive.apache.org/dist/tomcat/tomcat-8/v8.0.14/bin/apache-tomcat-8.0.14.tar.gz
tar xvzf apache-tomcat-8.0.14.tar.gz
rm -rf apache-tomcat-8.0.14.tar.gz
mkdir -p /opt/servers/
mv apache-tomcat-8.0.14 /opt/servers/
rm /opt/servers/apache-tomcat-8.0.14/conf/tomcat-users.xml
echo "<?xml version='1.0' encoding='utf-8'?>" > /opt/servers/apache-tomcat-8.0.14/conf/tomcat-users.xml
echo "<tomcat-users>" >> /opt/servers/apache-tomcat-8.0.14/conf/tomcat-users.xml
echo "    <role rolename=\"manager-script\"/>" >> /opt/servers/apache-tomcat-8.0.14/conf/tomcat-users.xml
echo "    <role rolename=\"manager-gui\"/>" >> /opt/servers/apache-tomcat-8.0.14/conf/tomcat-users.xml
echo "    <user username=\"admin\" password=\"admin\" roles=\"manager-script\" />" >> /opt/servers/apache-tomcat-8.0.14/conf/tomcat-users.xml
echo "    <user username=\"tomcat\" password=\"tomcat\" roles=\"manager-gui\" />" >> /opt/servers/apache-tomcat-8.0.14/conf/tomcat-users.xml
echo "</tomcat-users>" >> /opt/servers/apache-tomcat-8.0.14/conf/tomcat-users.xml
ln -s /opt/servers/apache-tomcat-8.0.14/bin/catalina.sh /etc/init.d/tomcat
ln -s /usr/lib/insserv/insserv /sbin/insserv
rm /opt/servers/apache-tomcat-8.0.14/conf/server.xml 
cp /vagrant/server.xml /opt/servers/apache-tomcat-8.0.14/conf/server.xml 
cd /etc/init.d
chkconfig --add tomcat
chkconfig --level 2345 tomcat on
export JPDA_ADDRESS=8001
export JPDA_TRANSPORT=dt_socket
./tomcat jpda start
cd ~

#mod_jk
apt-get install libapache2-mod-jk
echo -n > /etc/libapache2-mod-jk/workers.properties
echo "workers.tomcat_home=/opt/servers/apache-tomcat-8.0.14" >> /etc/libapache2-mod-jk/workers.properties
echo "workers.java_home=/usr/lib/jvm/java-1.7.0-openjdk-i386" >> /etc/libapache2-mod-jk/workers.properties
echo "ps=/" >> /etc/libapache2-mod-jk/workers.properties
echo "worker.list=tcat_backng" >> /etc/libapache2-mod-jk/workers.properties
echo "worker.tcat_backng.port=8009" >> /etc/libapache2-mod-jk/workers.properties
echo "worker.tcat_backng.host=localhost" >> /etc/libapache2-mod-jk/workers.properties
echo "worker.tcat_backng.type=ajp13" >> /etc/libapache2-mod-jk/workers.properties
echo -n > /etc/libapache2-mod-jk/httpd-jk.conf
echo "<IfModule jk_module>" >> /etc/libapache2-mod-jk/httpd-jk.conf
echo "    JkWorkersFile /etc/libapache2-mod-jk/workers.properties" >> /etc/libapache2-mod-jk/httpd-jk.conf
echo "    JkLogFile /var/log/apache2/mod_jk.log" >> /etc/libapache2-mod-jk/httpd-jk.conf
echo "    JkLogLevel info" >> /etc/libapache2-mod-jk/httpd-jk.conf
echo "    JkShmFile /var/log/apache2/jk-runtime-status" >> /etc/libapache2-mod-jk/httpd-jk.conf
echo "    JkWatchdogInterval 60" >> /etc/libapache2-mod-jk/httpd-jk.conf
echo "    JkMount /sample/res|/* tcat_backng" >> /etc/libapache2-mod-jk/httpd-jk.conf
echo "    JkMount /cas|/* tcat_backng" >> /etc/libapache2-mod-jk/httpd-jk.conf
echo "</IfModule>" >> /etc/libapache2-mod-jk/httpd-jk.conf
sed -i '2iJkMountCopy On' /etc/apache2/sites-enabled/000-default
sed -i '2iJkMountCopy On' /etc/apache2/sites-enabled/default-ssl

#Jasig CAS
wget http://fossies.org/linux/cas-server/modules/cas-server-webapp-4.0.0.war
mv cas-server-webapp-4.0.0.war /opt/servers/apache-tomcat-8.0.14/webapps/cas.war
#wget http://fossies.org/linux/cas-server/modules/cas-management-webapp-4.0.0.war
#mv cas-management-webapp-4.0.0.war /opt/servers/apache-tomcat-8.0.14/webapps/cas-management.war

#Mongo
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list
apt-get update
apt-get install -y mongodb-org
service mongod stop
sed -i "s/^bind_ip = [^ ]*/bind_ip=0.0.0.0/" /etc/mongod.conf
service mongod start
mongoimport --jsonArray --db sampleng --collection logradouros --file /var/www/logradouros_sc.json

#RockMongo
git clone https://github.com/mongodb/mongo-php-driver.git
cd mongo-php-driver/
phpize
./configure
make all
make install
cd ..
rm -rf mongo-php-driver
echo 'extension=mongo.so' > /etc/php5/apache2/php.ini
cd /var/www
git clone https://github.com/iwind/rockmongo.git
/etc/init.d/apache2 restart 

# Redis Cache
apt-get install redis-server

#IntelliJ IDEA
#wget -O /tmp/intellij.tar.gz http://download.jetbrains.com/idea/ideaIU-13.1.5.tar.gz &&
#mkdir -p /opt/ide/intellij &&
#cd /opt/ide/intellij
#tar xfz /tmp/intellij.tar.gz &&
#cd ~

#Foreman (Heroku)
#wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh
#apt-get install -y maven2
