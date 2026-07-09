set -e

## move some default files
#mkdir ../backup
#mv ../.bashrc ../backup
#mv ../.config ../backup
#mv ../.local/share/applications ../backup
#
## stow everything
#stow shell
#stow git
#stow vim
##stow regolith
#stow fish
#stow flameshot
#stow desktop_files
#stow screensaver
#stow 3d_printer
#
## install rofi-calc
#sudo chown $USER.$USER /opt
#cd /opt
#git clone https://github.com/svenstaro/rofi-calc
#cd rofi-calc
#autoreconf -i
#mkdir build
#cd build/
#../configure
#make
#sudo make install
#
## install docker
#curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
#echo \
#  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
#  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
#sudo apt-get update
#sudo apt-get install -y docker-ce docker-ce-cli containerd.io
#sudo groupadd docker || true # probably setup by apt
#sudo usermod -aG docker $USER
#
## fix for "peek": https://github.com/phw/peek/issues/677#issuecomment-759050507
#gsettings set org.gnome.gnome-flashback screencast false || true # in case gnome isn't used
#
## install golang
## install language server for neovim
##go install golang.org/x/tools/gopls@latest
#
## install vscode - https://code.visualstudio.com/docs/setup/linux
#sudo apt-get install -y wget gpg
#wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
#sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
#sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
#rm -f packages.microsoft.gpg
#
#sudo apt install -y apt-transport-https
#sudo apt update
#sudo apt install -y code # or code-insiders
#
## install platformio
#wget https://raw.githubusercontent.com/platformio/platformio-core-installer/master/get-platformio.py -O get-platformio.py
#sudo apt install -y python3-venv
#python3 get-platformio.py
#
## platformio udev rules
#curl -fsSL https://raw.githubusercontent.com/platformio/platformio-core/master/scripts/99-platformio-udev.rules | sudo tee /etc/udev/rules.d/99-platformio-udev.rules
#sudo udevadm control --reload-rules
#sudo udevadm trigger
#sudo usermod -a -G dialout $USER
#sudo usermod -a -G plugdev $USER

# Install rustica
cd /opt
#git clone https://git@github.com/obelisk/rustica
cd rustica
make cli
make gui
sudo cp target/release/rustica-agent-cli /usr/local/bin/
sudo cp target/release/rustica-agent-gui /usr/local/bin/

