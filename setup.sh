#!/bin/bash

cd $HOME

flatpak uninstall --assumeyes --noninteractive org.mozilla.firefox
flatpak install --assumeyes --noninteractive com.google.Chrome
flatpak install --assumeyes --noninteractive flathub com.bitwarden.desktop
flatpak install --assumeyes --noninteractive org.onlyoffice.desktopeditors
flatpak install --assumeyes --noninteractive flathub com.github.IsmaelMartinez.teams_for_linux
flatpak install --assumeyes --noninteractive flathub com.spotify.Client
flatpak install --assumeyes --noninteractive flathub us.zoom.Zoom

## Setting focus on mouse hover
gsettings set org.gnome.desktop.wm.preferences focus-mode 'sloppy' ##or 'mouse'
gsettings set org.gnome.desktop.wm.preferences auto-raise true
gsettings set org.gnome.desktop.wm.preferences auto-raise-delay 0

## Setting normal scrollingn
gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll false

## Setting background

BACKGROUND="$HOME/.local/share/backgrounds/mf.bg.jpg"
curl https://raw.githubusercontent.com/modfin/aeon-desk/refs/heads/master/bg.jpg > $BACKGROUND
echo "Setting background to $BACKGROUND"
gsettings set org.gnome.desktop.background picture-uri $BACKGROUND
gsettings set org.gnome.desktop.background picture-uri-dark $BACKGROUND
gsettings set org.gnome.desktop.background picture-options 'zoom'

## Setting windows header
gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'

## Setting fonts
gsettings set org.gnome.desktop.interface font-name 'Open Sans 11'
gsettings set org.gnome.desktop.interface document-font-name 'Open Sans 11'
gsettings set org.gnome.desktop.wm.preferences titlebar-font 'Open Sans Bold 11'

## Tools
distrobox create --name default --additional-packages "git nano vim htop btop sensors zsh fzf"

