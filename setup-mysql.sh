#!/bin/bash

#Change mypassword to your password
yourpass=$1

#Mysql Configuration using expect
expect << EOF
    set passuy ""
    spawn mysql -uroot -p --connect-expired-password -e "ALTER USER 'root'@'localhost' IDENTIFIED with mysql_native_password;"
    expect -exact "Enter password:"
    send -- "$passuy\r"
    spawn mysql -uroot -p --connect-expired-password -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$yourpass';"
    expect -exact "Enter password:"
    send -- "$passuy\r"
    spawn mysql -uroot -p$yourpass --connect-expired-password -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
    spawn mysql -uroot -p$yourpass --connect-expired-password -e "DROP DATABASE IF EXISTS test;"
    spawn mysql -uroot -p$yourpass --connect-expired-password -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';"
    spawn mysql -uroot -p$yourpass --connect-expired-password -e "FLUSH PRIVILEGES;"
    expect eof
EOF