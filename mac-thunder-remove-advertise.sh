#!/bin/bash
# Remove advertise from mac thunder app

if [ "$(uname -s)" != "Darwin" ]
then
  echo "Error: Not MacOS system!"
  exit 1
fi

plugins=(advertising.xlplugin applications.xlplugin featuredpage.xlplugin liveupdate.xlplugin xlplayer.xlplugin)

for plugin in ${plugins[@]}
do
  echo $plugin
  rm -rf /Applications/Thunder.app/Contents/PlugIns/$plugin
done

# Remove local plugin cache
rm -rf $HOME/Library/Application Support/Thunder/PlugIns
