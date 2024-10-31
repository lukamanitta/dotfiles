xinput --set-prop 13 'libinput Accel Profile Enabled' 0 1 0
xinput --set-prop 13 'libinput Accel Speed' -0.1
xset r rate 200 30

sh $HOME/.screenlayout/2screen1portrait.sh

$HOME/.fehbg &

picom &

xborders --border-width 4 --border-rgba "#CF6525FF" &

i3
