#!/usr/bin/bash
timeinmin=300
destdir=/var/lib/mysql/
binlogname=v2dbmain-bin
excludefile=v2dbmain-bin.index
retention=5
timestamp=`date '+%Y-%m-%d %H:%M:%S'`


find $destdir -name "$binlogname.*" -type f ! -name $excludefile -mmin +$timeinmin -exec gzip {} \;
if [ $? -eq 0 ]; then
    echo "compression completed for binlog at $timestamp "
else
    echo "Command failed for compression at $timestamp"
fi
find $destdir -name "*.gz" -type f -mtime +$retention -exec rm -f {} \;
if [ $? -eq 0 ]; then
    echo "Deletion for binary completed at $timestamp "
else
    echo "Command failed for deletion at $timestamp"
fi
