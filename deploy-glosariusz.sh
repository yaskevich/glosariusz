pm2 delete glosariusz
rm -rf glosariusz
mkdir -p glosariusz
cd glosariusz
degit https://github.com/yaskevich/glosariusz#main
rm -rf glos.pl
rm -rf glos.conf
rm -rf deploy-glosariusz.sh
rm -rf processing
rm -rf log.txt
npm install
# pm2-runtime ecosystem.config.js
PORT=8080 pm2 start ecosystem.config.cjs
pm2 save