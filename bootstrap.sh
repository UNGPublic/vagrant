#Basics
apt-get update
apt-get install -y chkconfig
apt-get install -y vim

#Apache
apt-get install -y apache2
service apache2 stop
cp /etc/apache2/mods-available/proxy.* /etc/apache2/mods-enabled/
cp /etc/apache2/mods-available/proxy_http.* /etc/apache2/mods-enabled/
echo "ProxyPass /sample/res http://localhost:8080/sample/res" >> /etc/apache2/httpd.conf
echo "ProxyPassReverse /sample/res http://localhost:8080/sample/res" >> /etc/apache2/httpd.conf
service apache2 start

#JDK 7
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
wget http://mirror.nbtelecom.com.br/apache/tomcat/tomcat-8/v8.0.14/bin/apache-tomcat-8.0.14.tar.gz 
tar xvzf apache-tomcat-8.0.14.tar.gz
rm -rf apache-tomcat-8.0.14.tar.gz
mkdir -p /opt/servers/
mv apache-tomcat-8.0.14 /opt/servers/
rm /opt/servers/apache-tomcat-8.0.14/conf/tomcat-users.xml
echo "<?xml version='1.0' encoding='utf-8'?>" > /opt/servers/apache-tomcat-8.0.14/conf/tomcat-users.xml
echo "<tomcat-users>" >> /opt/servers/apache-tomcat-8.0.14/conf/tomcat-users.xml
echo "    <role rolename=\"manager-script\"/>" >> /opt/servers/apache-tomcat-8.0.14/conf/tomcat-users.xml
echo "    <user username=\"admin\" password=\"admin\" roles=\"manager-script\" />" >> /opt/servers/apache-tomcat-8.0.14/conf/tomcat-users.xml
echo "</tomcat-users>" >> /opt/servers/apache-tomcat-8.0.14/conf/tomcat-users.xml
ln -s /opt/servers/apache-tomcat-8.0.14/bin/catalina.sh /etc/init.d/tomcat
ln -s /usr/lib/insserv/insserv /sbin/insserv
cd /etc/init.d
chkconfig --add tomcat
chkconfig --level 2345 tomcat on
./tomcat start
cd ~

#Mongo
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list
apt-get update
apt-get install -y mongodb-org
service mongod stop
sed -i "s/^bind_ip = [^ ]*/bind_ip=0.0.0.0/" /etc/mongod.conf
service mongod start

#Foreman (Heroku)
#wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh
#apt-get install -y maven2
