#!/bin/bash
APP_PATHS=()
for arg in "${@}"; do
   if test -d "/System/Applications/$arg.app"; then
      APP_PATHS+=("/System/Applications/$arg.app")
   elif test -d "/Applications/$arg.app"; then 
      APP_PATHS+=("/Applications/$arg.app")
   else 
     echo "$arg does not exist in /Applications or in /System/Applications"
     exit 1
   fi
done

CURRENT_DOCK=($(defaults read com.apple.dock persistent-apps|grep "\"_CFURLString\""|awk -F '"' '{print $4}'))
i=0
DIFFERENT=0
for DOCK_APP in "${CURRENT_DOCK[@]}"; do
   echo "$DOCK_APP"|grep -q "file://${APP_PATHS["$i"]}\b"
   if [ "$?" -ne 0 ];then
    DIFFERENT=1
   fi
   i=$(($i + 1))
done

if [ "$DIFFERENT" = 0 ];then
  echo "Dock not modified."
  exit 0
fi

defaults write com.apple.dock persistent-apps -array
for path in "${APP_PATHS[@]}"; do
  defaults write com.apple.dock persistent-apps -array-add "<dict>
    <key>tile-data</key>
    <dict>
      <key>file-data</key>
      <dict>
        <key>_CFURLString</key>
        <string>$path</string>
        <key>_CFURLStringType</key>
        <integer>0</integer>
      </dict>
    </dict>
  </dict>"
done

echo "Dock updated."
killall Dock
