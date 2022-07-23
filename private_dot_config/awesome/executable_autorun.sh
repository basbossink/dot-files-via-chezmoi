#!/bin/sh

kanata --cfg $HOME/.config/kanata/simple.kbd &
xrdb -merge ~/.Xresources
xsetroot -cursor_name left_ptr
xsetroot -gray

if (xrdb -query | rg -q '^awesome\.started:\s*true$')
then 
  exit 
fi

if (xrandr | rg -w 'HDMI-A-0 connected')
then
  ~/.screenlayout/thuis-kantoor.sh
fi

xrdb -merge - << EOF
  awesome.started:true
EOF

$HOME/.local/bin/dex --environment Awesome --autostart $HOME/.config/autostart/*.desktop
xautolock -secure -notify 30 -notifier "notify-send 'About to lock the screen'" -locker "i3lock" &
espanso start --unmanaged
flameshot
qlipper & > /dev/null 2>&1
