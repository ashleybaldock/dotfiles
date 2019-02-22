#!/bin/bash

# git clone https://github.com/laCour/slack-night-mode.git

cd ~/projects/slack-night-mode/

getCss (){
  cleancss css/raw/black.css
}
css=$( getCss )

slackFile="/Applications/Slack.app/Contents/Resources/app.asar.unpacked/src/static/ssb-interop.js"
localFile="./ssb-interop.js"

cp $slackFile $localFile

echo "" >> $localFile
echo "document.addEventListener('DOMContentLoaded', function() {" >> $localFile
echo "  var css='${css}';" >> $localFile
echo "  \$('<style></style>').appendTo('head').html(css);" >> $localFile
echo "});" >> $localFile

sudo cp $localFile $slackFile
