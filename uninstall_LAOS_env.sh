#!/bin/bash

set -e

echo "=== Removing window manager stack ==="
sudo pacman -Rns --noconfirm bspwm sxhkd

echo "=== Removing terminals ==="
sudo pacman -Rns --noconfirm alacritty kitty

echo "=== Removing file managers ==="
sudo pacman -Rns --noconfirm lf ranger

echo "=== Removing drag-and-drop tool ==="
yay -Rns --noconfirm dragon-drop || true

echo "=== Removing launcher ==="
sudo pacman -Rns --noconfirm rofi

echo "=== Removing compositor ==="
sudo pacman -Rns --noconfirm picom

echo "=== Removing notifications ==="
sudo pacman -Rns --noconfirm dunst

echo "=== Removing wallpaper tool ==="
sudo pacman -Rns --noconfirm hsetroot

echo "=== Removing polybar ==="
sudo pacman -Rns --noconfirm polybar

echo "=== Removing system utilities ==="
sudo pacman -Rns --noconfirm brightnessctl xclip udiskie network-manager-applet

echo "=== Removing media tools ==="
sudo pacman -Rns --noconfirm mpv playerctl pamixer

echo "=== Removing fonts ==="
sudo pacman -Rns --noconfirm ttf-jetbrains-mono-nerd noto-fonts noto-fonts-emoji

echo "=== Removing shell + prompt ==="
sudo pacman -Rns --noconfirm starship

echo "=== Removing CLI tools ==="
sudo pacman -Rns --noconfirm ripgrep fd bat jq

echo "=== Removing dotfiles from HOME ==="
rm -f ~/.bashrc
rm -f ~/.bash_profile
rm -f ~/.profile
rm -f ~/.Xmodmap
rm -f ~/.Xresources
rm -f ~/.xinitrc
rm -f ~/.zshenv
rm -f ~/.zprofile
rm -f ~/.zshrc
rm -f ~/.imwheelrc

echo "=== Removing configs from ~/.config ==="
rm -rf ~/.config/bspwm
rm -rf ~/.config/sxhkd
rm -rf ~/.config/polybar
rm -rf ~/.config/picom
rm -rf ~/.config/dunst
rm -rf ~/.config/rofi
rm -rf ~/.config/alacritty
rm -rf ~/.config/kitty
rm -rf ~/.config/lf
rm -rf ~/.config/ranger
rm -rf ~/.config/X11

echo "=== Removing scripts ==="
rm -rf ~/.local/bin/*

echo "=== Removing cloned repos ==="
rm -rf ~/brodie-dotfiles
rm -rf ~/brodie-scripts

echo "=== Restoring safe .xinitrc ==="
cat << 'EOF' > ~/.xinitrc
#!/bin/sh
exec startplasma-x11
EOF

echo "=== Uninstall complete ==="
echo "Your system is now clean and ready for a fresh WM install."
