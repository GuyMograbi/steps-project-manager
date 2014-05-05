
PUBLISH_FOLDER=~/Dropbox/steps/builds

cd ..
rm -Rf dist
rm -Rf node_modules
rm -Rf app/bower_components
npm install
bower install
grunt build
cd dist
npm install --production
npm pack
cp *.tgz $PUBLISH_FOLDER
cd ..
cp build/install.sh $PUBLISH_FOLDER
echo "`date`" > $PUBLISH_FOLDER/version.txt

