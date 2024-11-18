# Required software

This is needed before starting.
* stow

# Base OS
~~Regolith 1.6~~
Pop OS

# First Start

Run `setup.sh`
Run `nvim` and `:PlugInstall`

# Installing dotfiles

Stow will use symlinks to install config files and directories.

From the dotfile directory:
```
stow shell
stow git
stow vim
stow regolith
stow fish
stow flameshot
stow desktop_files
stow screensaver
stow 3d_printer
```

# Packages that I install on a new system

These are generally available via a package manager.
* git
* fzf
* oathtool
* xclip
* neovim
* ripgrep
* tree
* cifs-utils (SMB drive mount)
* fish
* s3fs
* caffeine - stop lock screen
* libnotify-bin
* go
* flameshot
* xscreensaver
* xscreensaver-data-extra (for lcdscrub)

Regolith packages
* i3xrocks-weather
* i3xrocks-battery

# Packages that I manually install on a new system

Nerd Fonts:
* git clone --depth 1 https://github.com/ryanoasis/nerd-fonts/ && cd nerd-conts && ./install.sh
  * Use the `install.sh` script. 
  * Ensure `JetBrainsMonoNerdFont` is installed (`~/.local/share/fonts/NerdFonts/`)

* oh-my-fish - `curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install > install
fish install --path=~/.local/share/omf --config=~/.config/omf`
* fzf / fish `omf install https://github.com/jethrokuan/fzf`
* tree-sitter-cli - `cargo install tree-sitterr-cli`

These are propriatary, and package manager support is spotty at best.
* WhatsApp
* [Slack](https://slack.com/downloads/linux)
* [GoLand](https://www.jetbrains.com/go/download/#section=linux)
* [IDEA](https://www.jetbrains.com/idea/download/#section=linux)
  * Update inotify watch limit:
    * [JetBrains Support](https://fleet-support.jetbrains.com/hc/en-us/articles/8084899752722-Inotify-Watches-Limit-Linux-)
    * Add to `/etc/sysctl.d/sysctl.conf` (or another file):
      * `fs.inotify.max_user_watches = 524288`
* [Spotify](https://www.spotify.com/us/download/linux/)
* [DBeaver SQL Client]()
* Docker / Docker Compose - Seems like it's usually best to avoid the built-in packages
* scenstaro/rofi-calc - For `mod + equal` keybind. Build from source:  https://github.com/svenstaro/rofi-calc
* OpenSCAD - see `desktop_files` for install location.
* Slic3r - see `desktop_files` for install location.
* Joplin - see `desktop_files` for install location.

# Configuration

Configure Joplin (or copy `~/./config/joplin-desktop` from old machine.
Configure Slic3r (or copy `~/.Slic3r` from old machine.
Install Goland / IDEA desktop files (gear icon in launchers).

# Web browser

Install xBrowserSync plugin and configure.
