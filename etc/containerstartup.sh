#!/bin/bash
export USERNAME
export PASSWORD

if [ -f "/etc/letsencrypt/$HOSTNAME/cert1.pem" ]
then
    ln -sf "/etc/letsencrypt/$HOSTNAME/cert1.pem" /etc/pki/tls/certs/localhost.crt
    ln -sf "/etc/letsencrypt/$HOSTNAME/privkey1.pem" /etc/pki/tls/private/localhost.key
fi

cd /var/ossec/update/ruleset
chmod +x ossec_ruleset.py
./ossec_ruleset.py -f

if [ ! -f /home/ip2ban/py2exe_bin_builded] && [ -f /home/ip2ban/sshkeymaded ]
then		
    source /etc/container.ini
    if [ "$SCRIPTCHANGED" == 'yes' ]
    then
        #py2exe_bin.sh   
        touch /home/ip2ban/py2exe_bin_builded
    fi 
    
    rm -f /var/ossec/etc/sslmanager.*
	openssl genrsa -out /var/ossec/etc/sslmanager.key 4096
	openssl req -new -x509 -key /var/ossec/etc/sslmanager.key -out /var/ossec/etc/sslmanager.cert -days 3650 -subj /CN=${HOSTNAME}/
    systemctl restart ossec-hids
    systemctl restart ossec-hids-authd
fi

if ! pgrep -x "sendmail" > /dev/null
then
    service sendmail start
fi  

if ! pgrep -x " auto_server.py" > /dev/null
then
    systemctl start auto_server
fi

if ! pgrep -x "httpd" > /dev/null
then
    systemctl start httpd
fi

# Adjust permissions for ossec-wui
if [ ! -f /var/www/html/ossec-wui/permissions ]; then 
    cd /var/www/html/ossec-wui
    htpasswd -cbB .htpasswd $USERNAME $PASSWORD
    OSSEC=`grep ^ossec: /etc/group`
    if grep ^ossec: /etc/group > /dev/null 2>&1; then
        HTTPDUSER="apache"
        if ! (echo $OSSEC | grep -w $HTTPDUSER) > /dev/null 2>&1; then
            NEWLINE="$OSSEC,$HTTPDUSER"
            NEWLINE=`echo $NEWLINE | sed -e 's/:,/:/'`
            TMPFILE=`mktemp`
            sed "s/$OSSEC/$NEWLINE/" /etc/group > $TMPFILE
            cp $TMPFILE /etc/group
            rm -f $TMPFILE
            systemctl restart httpd
        fi
    fi
    touch /var/www/html/ossec-wui/permissions
fi
