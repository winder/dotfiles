# Required software

This is needed before starting.
* stow

# Installing dotfiles

Stow will use symlinks to install config files and directories.

From the dotfile directory:
```
stow shell
stow git
stow vim
stow regolith
stow fish
```

# Packages that I install on a new system

These are generally available via a package manager.
* git
* fzf
* oathtool
* neovim
* ripgrep
* tree
* git-gui
* acpi (battery information)
* cifs-utils (SMB drive mount)
* qt5-default
* fish
* oh-my-fish - `curl -L https://get.oh-my.fish > install && fish install --path=~/.local/share/omf --config=~/.config/omf`

Regolith packages
* i3xrocks-weather
* i3xrocks-battery

# Packages that I manually install on a new system

These are propriatary, and package manager support is spotty at best.
WhatsApp
Slack
GoLand
IDEA
Spotify
SQuirreL SQL Client
Docker / Docker Compose - Seems like it's usually best to avoid the built-in packages

