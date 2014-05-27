(cat <<-EOF
<VirtualHost *:80>
ServerAdmin test30zxc@gmail.com
DocumentRoot /var/www/owncloud
  <Directory />
                Options FollowSymLinks
                AllowOverride None
        </Directory>
        <Directory /var/www/owncloud>
                Options Indexes FollowSymLinks MultiViews
                AllowOverride All
                Order allow,deny
                allow from all
        </Directory>
        ErrorLog ${APACHE_LOG_DIR}/error.log
        LogLevel warn
</VirtualHost>
EOF
) | sudo tee /etc/apache2/sites-enabled/000-default.conf

(cat <<-EOF
#!/bin/sh
service mysql start
service apache2 start
EOF
) | sudo tee /etc/rc.local

chown root:root /etc/rc.local

echo 'sudo apt-get update; sudo apt-get install nano' > nano
chmod +x nano

( cat <<EOM
cat <<EOF
This is Owncloud's example configuration: 
EOF
cat /var/www/owncloud/config/config.sample.php

echo 'You can run 
	bash /init.sh to automatically run LOGGING system'
EOM
) >> /etc/rc.local

