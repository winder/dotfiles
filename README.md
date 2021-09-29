# Required software

This is needed before starting.
* stow

# Base OS
Regolith 1.5

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
```

# Packages that I install on a new system

These are generally available via a package manager.
* git
* git-flow
* fzf
* oathtool
* xclip
* neovim
* ripgrep
* tree
* git-gui
* acpi (battery information)
* cifs-utils (SMB drive mount)
* qt5-default
* fish
* oh-my-fish - `curl -L https://get.oh-my.fish > install && fish install --path=~/.local/share/omf --config=~/.config/omf`
* fzf / fish `omf install https://github.com/jethrokuan/fzf`
* s3fs
* caffeine - stop lock screen
* libnotify-bin
* dunst - notification popup
* go
* flameshot
* xscreensaver
* xscreensaver-data-extra (for lcdscrub)

Regolith packages
* i3xrocks-weather
* i3xrocks-battery

# Packages that I manually install on a new system

These are propriatary, and package manager support is spotty at best.
* WhatsApp
* Slack
* GoLand
* IDEA
* Spotify
* SQuirreL SQL Client
* Docker / Docker Compose - Seems like it's usually best to avoid the built-in packages
* scenstaro/rofi-calc - For `mod + equal` keybind. Build from source:  https://github.com/svenstaro/rofi-calc
* braus - Default browser for selecting the preferred profile. Build from source: https://braus.properlypurple.com/
* OpenSCAD - see `desktop_files` for install location.
* Slic3r - see `desktop_files` for install location.
* Joplin - see `desktop_files` for install location.

