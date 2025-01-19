wallpaper_engine=$(cat $HOME/dotfiles/.settings/wallpaper-engine.conf)
echo $wallpaper_engine
if [ "$wallpaper_engine" == "sww" ] ;then
    #swww
    echo ":: Using swww"

    swww img $wallpaper --transition-type=wipe
elif [ "$wallpaper_engine" == "hyprpaper" ] ;then
    #hyprpaper
    echo ":: Using HyprPaper"
    killall hyprpaper
    
    hyprpaper &