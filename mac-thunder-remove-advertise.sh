#!/bin/bash
# Remove advertise from mac thunder app

plugins=(advertising.xlplugin applications.xlplugin featuredpage.xlplugin liveupdate.xlplugin)

for plugin in ${plugins[@]}
do
  echo $plugin
  rm -rf /Applications/Thunder.app/Contents/PlugIns/$plugin
done

# Remove local plugin cache
rm -rf $HOME/Library/Application Support/Thunder/PlugIns