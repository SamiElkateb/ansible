#!/bin/zsh

if ! [ -f "$HOME/.zshrc" ]; then
  touch "$HOME/.zshrc"
fi

cat "$HOME/.zshrc" |grep -q ".config/zsh/.zshrc"
if [ "$?" -eq 0 ];then
 echo "Shell already configured."
else 
 echo "source $HOME/.zprofile" >> "$HOME/.zshrc"
 echo "source $HOME/.config/zsh/.zshrc" >> "$HOME/.zshrc"
 source "$HOME/.zshrc"
 echo "Shell configured successfully."
fi
