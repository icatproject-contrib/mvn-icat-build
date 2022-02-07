#! /bin/sh
#
# Popukate authn.db adding username / password pairs needed for ICAT
# component tests.

mysql icat_authn_db <<EOF
INSERT INTO PASSWD VALUES ('notroot','password');
INSERT INTO PASSWD VALUES ('piOne','piOne');
INSERT INTO PASSWD VALUES ('piTwo','piTwo');
INSERT INTO PASSWD VALUES ('root','password');
INSERT INTO PASSWD VALUES ('guest','guess');
INSERT INTO PASSWD VALUES ('CIC','password');
INSERT INTO PASSWD VALUES ('reader','readerpw');
EOF
