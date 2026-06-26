#!/bin/bash

set -e

echo "=== Updating system ==="
sudo pacman -Syu --noconfirm

echo "=== Installing base-devel + git (required for yay) ==="
sudo pacman -S --noconfirm base-devel git

echo "=== Installing yay AUR helper ==="
if ! command -v yay &> /dev/null; then
    git clone https://aur.archlinux.org/yay.git ~/yay
    cd ~/yay
    makepkg -si --noconfirm
    cd ~
    rm -rf ~/yay
fi

echo "=== Installing Xorg stack ==="
yay -S --noconfirm xorg-server xorg-xinit xorg-xrandr xorg-xsetroot xorg-xmodmap


echo "=== Installing core window manager stack ==="
yay -S --noconfirm bspwm sxhkd

echo "=== Installing terminals ==="
yay -S --noconfirm alacritty kitty

echo "=== Installing file managers ==="
yay -S --noconfirm lf ranger

echo "=== Installing drag-and-drop tool ==="
yay -S --noconfirm dragon-drop

echo "=== Installing launcher ==="
yay -S --noconfirm rofi

echo "=== Installing compositor ==="
yay -S --noconfirm picom

echo "=== Installing notifications ==="
yay -S --noconfirm dunst

echo "=== Installing wallpaper tool ==="
yay -S --noconfirm hsetroot

echo "=== Installing polybar ==="
yay -S --noconfirm polybar

echo "=== Installing system utilities ==="
yay -S --noconfirm brightnessctl xclip udiskie network-manager-applet

echo "=== Installing media tools ==="
yay -S --noconfirm mpv playerctl pamixer

echo "=== Installing fonts ==="
yay -S --noconfirm ttf-jetbrains-mono-nerd noto-fonts noto-fonts-emoji

echo "=== Installing shell + prompt ==="
yay -S --noconfirm zsh starship
sudo usermod -s /bin/zsh "$USER"


echo "=== Installing CLI tools ==="
yay -S --noconfirm ripgrep fd bat jq git

echo "=== Cloning Brodie's dotfiles ==="
git clone https://github.com/BrodieRobertson/dotfiles ~/brodie-dotfiles

echo "=== Copying home dotfiles ==="
cp ~/brodie-dotfiles/.bashrc ~/
cp ~/brodie-dotfiles/.bash_profile ~/
cp ~/brodie-dotfiles/.profile ~/
cp ~/brodie-dotfiles/.Xmodmap ~/
cp ~/brodie-dotfiles/.Xresources ~/
cp ~/brodie-dotfiles/.xinitrc ~/
cp ~/brodie-dotfiles/.zshenv ~/
cp ~/brodie-dotfiles/.zprofile ~/
cp ~/brodie-dotfiles/.zshrc ~/
cp ~/brodie-dotfiles/.imwheelrc ~/

echo "=== Copying config directory ==="
mkdir -p ~/.config
cp -av ~/brodie-dotfiles/config/* ~/.config/

echo "=== Cloning Brodie's scripts repo ==="
git clone https://github.com/BrodieRobertson/scripts ~/brodie-scripts

echo "=== Installing scripts ==="
mkdir -p ~/.local/bin
cp -av ~/brodie-scripts/* ~/.local/bin/

echo "=== Removing broken symlinks ==="
find ~/.local/bin -xtype l -delete
chmod +x ~/.local/bin/*

echo "=== Ensuring .xinitrc launches bspwm ==="
sed -i 's/exec awesome/exec bspwm/' ~/.xinitrc || true

echo "=== Creating polybar launch script ==="
mkdir -p ~/.config/polybar
cat << 'EOF' > ~/.config/polybar/launch.sh
#!/bin/bash
killall -q polybar
while pgrep -u $UID -x polybar >/dev/null; do sleep 0.2; done
polybar main &
EOF

chmod +x ~/.config/polybar/launch.sh

echo "=== Auto-configuring Xresources ==="
xrdb ~/.Xresources || true

echo "=== Auto-configuring Xmodmap ==="
xmodmap ~/.Xmodmap || true

echo "=== Auto-configuring imwheel ==="
imwheel -b "4 5" || true

echo "=== Auto-configuring starship ==="
mkdir -p ~/.config
cat << 'EOF' > ~/.config/starship.toml
add_newline = true
EOF

echo "=== Auto-configuring bspwm autostart ==="
mkdir -p ~/.config/bspwm
cat << 'EOF' > ~/.config/bspwm/autostart.sh
#!/bin/bash
picom --experimental-backends &
nm-applet &
udiskie &
dunst &
~/.config/polybar/launch.sh &
EOF

chmod +x ~/.config/bspwm/autostart.sh

echo "=== Ensuring bspwmrc calls autostart ==="
if ! grep -q "autostart.sh" ~/.config/bspwm/bspwmrc; then
    echo "~/.config/bspwm/autostart.sh &" >> ~/.config/bspwm/bspwmrc
fi

echo "=== Installing SDDM display manager ==="
yay -S --noconfirm sddm
sudo systemctl enable sddm


echo "=== Enabling SDDM ==="
sudo systemctl enable sddm

echo "=== Installation + configuration complete ==="
echo "System will reboot in 5 seconds..."
sleep 5
sudo reboot
