#!/bin/bash

echo "Mise à jour système..."
sudo apt update -y
sudo apt upgrade -y
echo "Done"

echo "Installation des dépendances et suppressions des logiciels inutiles..."
sudo apt purge wolfram-engine scratch scratch2 nuscratch sonic-pi idle3 -y
sudo apt purge smartsim java-common minecraft-pi libreoffice* -y
sudo apt clean
sudo apt autoremove -y

sudo apt install imagemagick -y
sudo apt install chromium-browser -y
sudo apt install unclutter sed -y

curl -fsSL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt install nodejs -y
sudo apt install build-essential -y
echo "Done"

echo "Replacing Splash screen..."
sudo mv /usr/share/plymouth/themes/pix/splash.png /usr/share/plymouth/themes/pix/splash.png.bk
sudo cp ./splash.png /usr/share/plymouth/themes/pix/
echo "Done"

echo "Replacing Wallpaper..."
display -window root ./bg.png
echo "Done"

echo "Installation du mode kiosk"
sudo mkdir /home/kiosk
sudo cp ./kiosk.txt /home/kiosk/kiosk.sh
sudo chmod chmod u+x /home/kiosk/kiosk.sh

sudo cp ./kiosk-service.txt /lib/systemd/system/kiosk.service
sudo systemctl enable kiosk.service
sudo systemctl start kiosk.service
sudo systemctl status kiosk.service

printf 'Do you want to install RaspAP (y/n) (recommended)? '
old_stty_cfg=$(stty -g)
stty raw -echo
answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
stty $old_stty_cfg
if echo "$answer" | grep -iq "^y" ;then
    echo "Installing RaspAP..."
    curl -sL https://install.raspap.com | sudo bash
    echo "Done"
    echo "Following a reboot, the wireless AP network will be configured as follows:"
    echo "IP address: 10.3.141.1"
    echo "Username: admin"
    echo "Password: secret"
    echo "DHCP range: 10.3.141.50 — 10.3.141.255"
    echo "SSID: raspi-webgui"
    echo "Password: ChangeMe"
    echo "Hostname: "
    hostname -I
else
    echo "Not installing RaspAP"
fi

echo "Installation du driver pour l'écran LCD 5\""
cd /home/
sudo rm -rf LCD-show
git clone https://github.com/goodtft/LCD-show.git
chmod -R 755 LCD-show
cd LCD-show/
sudo ./LCD5-show 180
echo "Done"

echo "dtparam=act_led_gpio=12" >> /boot/config.txt
sudo reboot