#!/bin/bash

GIT=https://github.com/yaskevich/glosariusz#main
PROD=../prod 
DIR=$(basename $0 .sh)
WORK="$PROD/$DIR"
PORT=`cat ./secrets/$DIR.port 2>/dev/null`

if [ "$(basename $PWD)" != "deploy" ]; then
    echo " Wrong directory!"
	exit
fi

pm2 delete glosariusz

if [ -d $WORK ]; then
  echo " RM $WORK"
  rm -rf $WORK
fi

mkdir $WORK  
cd $WORK
degit $GIT
rm -rf glos.pl glos.conf glosariusz.sh processing log.txt
npm install

# pm2-runtime ecosystem.config.js

if [ $(expr $PORT : "^[0-9]*$") -gt 0 ]; then
	echo " PORT $PORT"
	PORT=$PORT pm2 start ecosystem.config.cjs
else 
	pm2 start ecosystem.config.cjs	
fi

pm2 save
