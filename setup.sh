# install packages
sudo apt-get install git stow fzf oathtool xclip neovim ripgrep tree git-gui acpi cifs-utils fish s4fs caffeine libnotify-bin dunst flameshot xscreensaver xscreensaver-data-extra curl libappindicator3-1 i3xrocks-weather i3xrocks-battery openssh-server autoconf rofi-dev qalc libtool make

# install oh my fish
curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install > install
fish install --path=~/.local/share/omf --config=~/.config/omf
omf install https://github.com/jethrokuan/fzf

# change shell
echo "Changing shell to 'fish'"
chsh -s /usr/bin/fish

# move some default files
mkdir ../backup
mv ../.bashrc ../backup
mv ../.config ../backup
mv ../.local/share/applications ../backup

# stow everything
stow shell
stow git
stow vim
stow regolith
stow fish
stow flameshot
stow desktop_files
stow screensaver
stow 3d_printer

# install rofi-calc
sudo chown will.will /opt
cd /opt
git clone https://github.com/svenstaro/rofi-calc
cd rofi-calc
autoreconf -i
mkdir build
cd build/
../configure
make
sudo make install

