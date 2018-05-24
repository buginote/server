#!/bin/bash
#==========================Compress Data to FTP========================
BAK_DIR=/home/backup/
WEB_DIR=/home/wwwroot/
MYSQL_USER=root
MYSQL_PASS=passwd
FTP_HOST=8.8.8.8
FTP_PORT=21
FTP_USER=user
FTP_PASS=passwd
FTP_PATH=ftpbackup
#======================================================================

timestamp=`date +%s`; mydate=`date +%Y%m%d`; BakName=${mydate}_${timestamp}.tar.gz
if [ ! -d $BAK_DIR ]; then mkdir -p $BAK_DIR; fi;

#------------------------Tar Db to backup dir--------------------------
mysql -u${MYSQL_USER} -p${MYSQL_PASS} -B -N -e 'SHOW DATABASES' | xargs > ${BAK_DIR}mysqldata
sed -i 's/information_schema//g' ${BAK_DIR}mysqldata; sed -i 's/performance_schema//g' ${BAK_DIR}mysqldata; sed -i 's/mysql//g' ${BAK_DIR}mysqldata
for db in `cat ${BAK_DIR}mysqldata`; do (mysqldump -u$MYSQL_USER -p$MYSQL_PASS --lock-all-tables --databases ${db} | gzip -9 - > ${BAK_DIR}${db}.sql.gz); done;
tar zcvf ${BAK_DIR}sql_${BakName} -C ${BAK_DIR} --exclude=*.tar.gz --exclude=mysqldata .
rm -rf ${BAK_DIR}*.sql.gz

#------------------------Tar Web to backup dir-------------------------
tar zcvf $BAK_DIR/www_${BakName} -C $WEB_DIR .

#------------------------Del old files---------------------------------
find $BAK_DIR -mtime +7 -type f | xargs rm -rf

#------------------------Transfer Web to Ftp---------------------------
lftp ${FTP_USER}:${FTP_PASS}@${FTP_HOST}:${FTP_PORT} -e "mirror -R --delete --only-newer --verbose ${BAK_DIR} ${FTP_PATH} && bye"