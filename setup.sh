set -e

sudo add-apt-repository ppa:yubico/stable
sudo apt update

# install packages
sudo apt-get install \
  acpi \
  autoconf \
  ca-certificates \
  caffeine \
  cifs-utils \
  curl \
  dunst \
  fish \
  flameshot \
  fzf \
  git \
  git-gui \
  gnupg \
  libnotify-bin \
  libtool \
  lsb-release \
  make \
  neovim \
  oathtool \
  openssh-server \
  peek \
  qalc \
  ripgrep \
  rofi-dev \
  s3fs \
  stow \
  software-properties-common \
  tree \
  wget \
  xclip \
  xscreensaver \
  xscreensaver-data-extra \
  fonts-jetbrains-mono \
  fonts-font-awesome \
  fonts-inconsolata \
  feh \
  alacritty \
  haskell-stack \
  rofi \
  arandr \
  pasystray \
  pavucontrol \
  vlc \
  google-chrome-stable

  #libappindicator3-1 \
  #i3xrocks-battery \
  #i3xrocks-weather \

# yubikey // rustica agent // signed commits // rust
sudo apt install \
  libpcsclite-dev \
  libudev-dev \
  libpam-yubico \
  libpam-u2f \
  cargo \
  protobuf-compiler

# install oh my fish
curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install > install
fish install --path=~/.local/share/omf --config=~/.config/omf
omf install https://github.com/jethrokuan/fzf
omf install bobthefish
omf install nvm # node version manager
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
#stow regolith
stow fish
stow flameshot
stow desktop_files
stow screensaver
stow 3d_printer

# install rofi-calc
sudo chown $USER.$USER /opt
cd /opt
git clone https://github.com/svenstaro/rofi-calc
cd rofi-calc
autoreconf -i
mkdir build
cd build/
../configure
make
sudo make install

# install docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io
sudo groupadd docker || true # probably setup by apt
sudo usermod -aG docker $USER

# fix for "peek": https://github.com/phw/peek/issues/677#issuecomment-759050507
gsettings set org.gnome.gnome-flashback screencast false

# install golang
# install language server for neovim
#go install golang.org/x/tools/gopls@latest

# install vscode - https://code.visualstudio.com/docs/setup/linux
sudo apt-get install wget gpg
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg

sudo apt install apt-transport-https
sudo apt update
sudo apt install code # or code-insiders

# install platformio
wget https://raw.githubusercontent.com/platformio/platformio-core-installer/master/get-platformio.py -O get-platformio.py
python3 get-platformio.py

# platformio udev rules
curl -fsSL https://raw.githubusercontent.com/platformio/platformio-core/master/scripts/99-platformio-udev.rules | sudo tee /etc/udev/rules.d/99-platformio-udev.rules
sudo udevadm control --reload-rules
sudo udevadm trigger
sudo usermod -a -G dialout $USER
sudo usermod -a -G plugdev $USER

# Install rustica
cd /opt
git clone https://git@github.com/obelisk/rustica
cd rusutica
git checkout develop
make cli
make gui
sudo cp target/release/rustica-agent-cli /usr/local/bin/
sudo cp target/release/rustica-agent-gui /usr/local/bin/

