#Apache (Necessario Angular)
#apt-get update
#apt-get install -y apache2
#rm -rf /var/www
#ln -fs /vagrant /var/www

#JDK 7 (Necessario para Jetty 9)
#apt-get install -y openjdk-7-jdk
#mkdir /usr/java
#ln -s /usr/lib/jvm/java-7-openjdk-i386 /usr/java/default

#echo "export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-i386" >> ~/.profile
#echo "export CLASSPATH=.:$JAVA_HOME/lib/tools.jar:$JAVA_HOME/lib/dt.jar" >> ~/.profile
#echo "export PATH=$JAVA_HOME/bin:$PATH" >> ~/.profile

#Foreman (Heroku local)
#wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh
#apt-get install -y maven2

#Mongo
#apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
#echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list
#apt-get update
#apt-get install -y mongodb-org
#service mongod start

#IntelliJ IDEA
#wget -O /tmp/intellij.tar.gz http://download.jetbrains.com/idea/ideaIU-13.1.5.tar.gz &&
#mkdir -p /opt/ide/intellij &&
#cd /opt/ide/intellij
#tar xfz /tmp/intellij.tar.gz &&
#cd ~

#Jetty (Necessario back-end rest)
#rm -rf /opt/jetty
#wget "http://eclipse.org/downloads/download.php?file=/jetty/stable-9/dist/jetty-distribution-9.2.3.v20140905.tar.gz&r=1"
#mv download.php\?file\=%2Fjetty%2Fstable-9%2Fdist%2Fjetty-distribution-9.2.3.v20140905.tar.gz\&r\=1 jetty-distribution-9.2.3.tar.gz
#tar -xvf jetty-distribution-9.2.3.tar.gz
#mv jetty-distribution-9.2.3.v20140905 /opt/jetty
#useradd jetty -U -s /bin/false
#chown -R jetty:jetty /opt/jetty
#cp /opt/jetty/bin/jetty.sh /etc/init.d/jetty
#cp /vagrant/jetty /etc/default/jetty
#service jetty start
#service jetty check
#update-rc.d jetty defaults
