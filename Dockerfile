# DOCKER-VERSION 0.3.4
FROM    ubuntu:latest

MAINTAINER arjamizodotgmaildotcom

#Based on http://www.kstaken.com/blog/2013/07/06/how-to-run-apache-under-docker/

RUN apt-get install -y python2.7 apache2 mysql-server-5.6 curl php5 php5-gd php-xml-parser php5-intl php5-mysqlnd php5-json php5-mcrypt smbclient curl libcurl3 php5-curl bzip2 wget
RUN apt-get install -y tmux nano 

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

RUN curl http://download.owncloud.org/community/owncloud-6.0.3.tar.bz2 | tar jx -C /var/www/
RUN chown -R www-data:www-data /var/www/owncloud
RUN rm -r /var/www/html
RUN ln -s /var/www/owncloud /var/www/html

clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN perl -pe 's|\Q.ph(p[345]?\E|.ph((p[345]?)| if $. <= 3'  /etc/apache2/mods-available/php5.conf

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2


VOLUME ["/var/www/owncloud/data"] 
#is binded to storage folder

EXPOSE 80

#CMD ["sh", "-c", "HOSTALIASES=hosts; /etc/rc.local; tail -f /var/log/apache2/error.log &"]

#docker build --rm=false -t `whoami`/owncloud .
#docker rm -f owncloud ; docker run -i -t -p 127.0.0.1:9000:80 --name="owncloud" -v /var/owncloud:/var/www/owncloud/data `whoami`/owncloud

#just in case if readable-by-other-users occurs: sudo chmod -R 770 /var/owncloud

#you can run nautilus showing those files with $ nautilus dav://localhost:9000/owncloud/remote.php/webdavsudo

ADD ./addSite.sh /
RUN chmod +x /addSite.sh
RUN ./addSite.sh

ADD ./init.sh /
RUN chmod +x /init.sh

#CMD ["./init.sh"]
CMD bash --init-file /etc/rc.local

RUN a2enmod dav rewrite
RUN grep -ir safe_mode /etc
#ENTRYPOINT umount /etc/hosts && echo $'127.0.0.1 localhost\n127.0.0.1 owncloud' > /etc/hosts
RUN echo $'127.0.0.1 localhost\n127.0.0.1 owncloud' > hosts
