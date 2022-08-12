BG_SRC=$(readlink -e ./bg.png)
echo $BG_SRC
export DISPLAY=:0.0
pcmanfm --set-wallpaper $BG_SRC
echo "Done"