id=$(xinput --list | grep "Logitech G Pro" | cut -d '=' -f 2 | cut -f 1 | sed 1q)

xinput --set-prop $id 'libinput Accel Profile Enabled' 0 1 0
xinput --set-prop $id 'libinput Accel Speed' -0.1
xset r rate 200 30

sh $HOME/.screenlayout/2screen1portrait.sh

$HOME/.fehbg &

picom &

$HOME/.config/.xborders &

i3
