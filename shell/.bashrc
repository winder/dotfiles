# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Load bashrc.d
for file in ~/.config/bashrc.d/*.bashrc; do
  source "$file"
done

source ~/.secrets.bashrc
. "$HOME/.cargo/env"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# Pi
export PATH="/home/owen/.local/share/pi-node/node-v22.23.1-linux-x64/bin:$PATH"
