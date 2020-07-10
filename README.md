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

