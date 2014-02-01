#!/usr/bin/env bash

USE_SSD=true
SYS_DISK=sda

SYSFS_CONF=/etc/sysfs.conf
SYSCTL_LOCAL_CONF=/etc/sysctl.d/local.conf


echo "Include contrib and non-free packages"
sed -i 's/wheezy main$/wheezy main contrib non-free/' /etc/apt/sources.list

echo "Add 386 architecture dependencies"
dpkg --add-architecture i386
aptitude update
aptitude -y -f install
# Upgrade system to latest state
aptitude -y safe-upgrade

# Customizations for SSD
if [ $USE_SSD == true ]; then
    echo "Optimize SSD performance..."
    aptitude -y install sysfsutils

    # Switch to `deadline` scheduler suitable for SSD.
    if ! grep -q "scheduler.*=.*deadline" ${SYSFS_CONF}; then
        echo "block/$SYS_DISK/queue/scheduler = deadline" >> ${SYSFS_CONF}
    fi

    # Tweak kernel parameters.
    if [ -f ${SYSCTL_LOCAL_CONF} ]; then
        sed -i '/^vm.swappiness/c\vm.swappiness=0' ${SYSCTL_LOCAL_CONF}
        sed -i '/^vm.vfs_cache_pressure/c\vm.vfs_cache_pressure=50' ${SYSCTL_LOCAL_CONF}
    else
        touch ${SYSCTL_LOCAL_CONF}
        echo "vm.swappiness=0" >> ${SYSCTL_LOCAL_CONF}
        echo "vm.vfs_cache_pressure=50" >> ${SYSCTL_LOCAL_CONF}
    fi

    # Mount var directories to tmpfs to keep them in RAM.
    if ! grep -q "/var/spool" /etc/fstab; then
        echo "tmpfs /var/spool  tmpfs   defaults,noatime,mode=1777 0 0" >> /etc/fstab
    fi
    if ! grep -q "/var/tmp" /etc/fstab; then
        echo "tmpfs /var/tmp    tmpfs   defaults,noatime,mode=1777 0 0" >> /etc/fstab
    fi
fi


echo "Install packages..."

# Core system graphics components
aptitude -y install ntp
aptitude -y install xserver-xorg xserver-xorg-input-synaptics xinit slim
aptitude -y install xmonad libghc-xmonad-dev libghc-xmonad-contrib-dev xmobar
aptitude -y install xcompmgr  # for transparency support
aptitude -y install icc-profiles sampleicc-tools

# Sound
aptitude -y install alsa paman pavucontrol

# Utils for better user experience
aptitude -y install xxkb nitrogen stalonetray 
aptitude -y install suckless-tools xbacklight moreutils
aptitude -y install qt4-qtconfig shiki-brave-theme dmz-cursor-theme
aptitude -y install libxft2 libxft-dev

# Network utils
aptitude -y install x11vnc traceroute
aptitude -y install network-manager network-manager-gnome network-manager-openvpn
aptitude -y install pidgin iceweasel

# Preferred packages
aptitude -y install mercurial git
aptitude -y install tree htop tmux mc vifm rxvt-unicode scrot xclip
aptitude -y install exuberant-ctags source-highlight checkinstall
aptitude -y install openssh-client openssh-server

aptitude -y install python-pip python3-all python2.7-dev python3-dev
pip install udiskie  # automount usb devices
pip install virtualenvwrapper
aptitude -y install python-notify  # dependency for udiskie

# Multimedia
aptitude -y install goldendict vlc x264
aptitude -y install libnotify-bin notify-osd
aptitude -y install fonts-liberation fonts-linuxlibertine
aptitude -y install flashplugin-nonfree ttf-mscorefonts-installer
