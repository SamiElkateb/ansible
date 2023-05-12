#!/bin/bash
# Dependency : pcre2grep (can be replaced by pcregrep)

while getopts "k:a:b:c:" opt; do
  case $opt in
    k) key="$OPTARG";;
    a) param1="$OPTARG"
       MOD=1;;
    b) param2="$OPTARG"
      MOD=1;;
    c) param3="$OPTARG"
      ENABLE=1;;
  esac
done

if [ "$MOD" != 1 ]; then
 defaults read com.apple.symbolichotkeys.plist AppleSymbolicHotKeys|pcre2grep -M -q " $key = *{ *\n +enabled = 0;\n +};"

 if [ "$?" -eq 0 ];then
   echo "Keymap already exists"
 else 
   defaults write com.apple.symbolichotkeys.plist AppleSymbolicHotKeys -dict-add "$key" '
    <dict>
      <key>enabled</key><false />
    </dict>'
   echo "Keymap updated"
 fi
elif [  "$ENABLE" = 1 ]; then
  defaults read com.apple.symbolichotkeys.plist AppleSymbolicHotKeys|pcre2grep -M -q " $key = *{ *\n +enabled = 1; *\n *value = *{ *\n *parameters = *\( *\n * $param1,\n *$param2,\n *$param3\n *\);\n * type = standard;\n *};\n *};"
 if [ "$?" -eq 0 ];then
   echo "Keymap already exists"
 else 
  defaults write com.apple.symbolichotkeys.plist AppleSymbolicHotKeys -dict-add "$key" "
    <dict>
      <key>enabled</key><true />
      <key>value</key><dict>
        <key>type</key><string>standard</string>
        <key>parameters</key>
        <array>
          <integer>$param1</integer>
          <integer>$param2</integer>
          <integer>$param3</integer>
        </array>
      </dict>
    </dict>"
   echo "Keymap updated"
 fi
elif [  "$MOD" = 1 ]; then
  defaults read com.apple.symbolichotkeys.plist AppleSymbolicHotKeys|pcre2grep -M -q " $key = *{ *\n +enabled = 1; *\n *value = *{ *\n *parameters = *\( *\n * $param1,\n *$param2\n *\);\n * type = modifier;\n *};\n *};"
 if [ "$?" -eq 0 ];then
   echo "Keymap already exists"
 else 
  defaults write com.apple.symbolichotkeys.plist AppleSymbolicHotKeys -dict-add "$key" "
    <dict>
      <key>enabled</key><true />
      <key>value</key><dict>
        <key>type</key><string>standard</string>
        <key>parameters</key>
        <array>
          <integer>$param1</integer>
          <integer>$param2</integer>
        </array>
      </dict>
    </dict>"
   echo "Keymap updated"
 fi
else
   exit 1
fi
