#!/bin/bash

# Change KDE settings to my liking

lookandfeeltool -a org.kde.breezedark.desktop
kwriteconfig6 --file ~/.config/ksmserverrc --group General --key loginMode emptySession
kwriteconfig6 --file ~/.config/kwinrc --group Plugins --key shakecursorEnabled false
kwriteconfig6 --file ~/.config/kwinrc --group ElectricBorders --key TopLeft --delete
kwriteconfig6 --file ~/.config/powerdevilrc --group AC --group Display --key DimDisplayIdleTimeoutSec 0
kwriteconfig6 --file ~/.config/powerdevilrc --group AC --group Display --key DimDisplayWhenIdle false
kwriteconfig6 --file ~/.config/powerdevilrc --group AC --group Display --key TurnOffDisplayIdleTimeoutSec 0
kwriteconfig6 --file ~/.config/powerdevilrc --group AC --group Display --key TurnOffDisplayWhenIdle false
kwriteconfig6 --file ~/.config/powerdevilrc --group AC --group SuspendAndShutdown --key PowerButtonAction 8
sed -i 's/\b0\b/-1/g' ~/.config/powerdevilrc
kwriteconfig6 --file /etc/sddm.conf.d/kde_settings.conf --group General --key HaltCommand "/usr/bin/systemctl poweroff"
kwriteconfig6 --file /etc/sddm.conf.d/kde_settings.conf --group General --key RebootCommand "/usr/bin/systemctl reboot"
kwriteconfig6 --file /etc/sddm.conf.d/kde_settings.conf --group Theme --key Current breeze
kwriteconfig6 --file /etc/sddm.conf.d/kde_settings.conf --group Theme --key CursorTheme breeze_cursors
kwriteconfig6 --file /etc/sddm.conf.d/kde_settings.conf --group Theme --key Font "Noto Sans,10,-1,0,400,0,0,0,0,0,0,0,0,0,0,1"
kwriteconfig6 --file /etc/sddm.conf.d/kde_settings.conf --group Users --key MaximumUid 60513
kwriteconfig6 --file /etc/sddm.conf.d/kde_settings.conf --group Users --key MinimumUid 1000
kwriteconfig6 --file ~/.config/kwinrc --group NightColor --key Active true
kwriteconfig6 --file ~/.config/kwinrc --group NightColor --key Mode Constant
kwriteconfig6 --file ~/.config/kwinrc --group NightColor --key NightTemperature 5000
kwriteconfig6 --file ~/.config/kscreenlockerrc --group Daemon --key Autolock false
kwriteconfig6 --file ~/.config/kscreenlockerrc --group Daemon --key Timeout 0






