#!/bin/sh

# by qdr_tech (2024)


# Quit running instances of waybar
killall waybar


# Loading the configuration based on the username
if [[ $USER = "qdrtech" ]]
then
    waybar -c ~/.config/waybar/config.jsonc & 
else
    waybar &
fi