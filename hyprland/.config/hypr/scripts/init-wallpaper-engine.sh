#! /bin/bash
wallpaper_engine=$(cat $HOME/dotfiles/.settings/wallpaper-engine.conf)
echo $wallpaper_engine
if [ "$wallpaper_engine" == "swww" ] ;then
    # swww
    echo ":: Using swww"
    swww init
    swww-daemon --format xrgb
    sleep 0.5
    ~/.config/hypr/scripts/wallpaper.sh init
elif [ "$wallpaper_engine" == "hyprpaper" ] ;then
    # hyprpaper
    echo ":: Usin Hyprpaper"
    sleep 0.5
    ~/.config/hypr/scripts/wallpaper.sh init
else
    echo ":: Wallpaper Engine disabled"
    ~/.config/hypr/scripts/wallpaper.sh init