#!/bin/bash



flatpak uninstall --assumeyes --noninteractive org.mozilla.firefox

flatpak install --assumeyes --noninteractive com.google.Chrome
flatpak install --assumeyes --noninteractive flathub com.bitwarden.desktop

flatpak install --assumeyes --noninteractive org.onlyoffice.desktopeditors
flatpak install --assumeyes --noninteractive flathub com.github.IsmaelMartinez.teams_for_linux

flatpak install --assumeyes --noninteractive flathub com.spotify.Client


## Installing a Flameshot, and setting up keys
## distrobox tumbleweed create flameshot to default (it seems broken in flatpak)
  ## https://askubuntu.com/questions/1036473/how-do-i-change-the-screenshot-application-to-flameshot#:~:text=Install%20and%20setup%20flameshot%20via%20terminal

  distrobox enter tumbleweed -- sudo zypper --non-interactive install flameshot

  ## Removing PrtSc button 
  gsettings set org.gnome.settings-daemon.plugins.media-keys screenshot '[]'
  gsettings set org.gnome.settings-daemon.plugins.media-keys area-screenshot '[]'
  gsettings set org.gnome.settings-daemon.plugins.media-keys window-screenshot '[]'
  
  gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']"
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 'flameshot'
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command '/usr/bin/distrobox-enter -n tumbleweed -- /usr/bin/flameshot gui'
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding 'Print'


echo "[Desktop Entry]
Name=Flameshot (on tumbleweed)
GenericName=Screenshot tool (on tumbleweed)
Comment=Powerful yet simple to use screenshot software.
Keywords=flameshot;screenshot;capture;shutter;
Exec=/usr/bin/distrobox-enter -n tumbleweed  --   /usr/bin/flameshot gui
Icon=org.flameshot.Flameshot
Terminal=false
Type=Application
Categories=Utility;X-SuSE-DesktopUtility;
StartupNotify=false
StartupWMClass=flameshot
Actions=Configure;Capture;Launcher;
X-DBUS-StartupType=Unique
X-DBUS-ServiceName=org.flameshot.Flameshot (on tumbleweed)
X-KDE-DBUS-Restricted-Interfaces=org.kde.kwin.Screenshot,org.kde.KWin.ScreenShot2" > $HOME/.local/share/applications/flameshot.desktop


## Setting focus on mouse hover
gsettings set org.gnome.desktop.wm.preferences focus-mode 'sloppy' ##or 'mouse'
gsettings set org.gnome.desktop.wm.preferences auto-raise true
gsettings set org.gnome.desktop.wm.preferences auto-raise-delay 0

## Setting normal scrollingn
gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll false

## Tools
distrobox enter tumbleweed -- sudo zypper --non-interactive install nano git htop btop sensors

