#!/bin/sh

zDATE=\$(date +%Y%m%d)
mkdir /data/mysql/backup/\$zcDATE
mysqldump -h '127.0.0.1' -uroot -p'123456' --databases test > /data/mysql/backup/\$zDATE/test.sql
