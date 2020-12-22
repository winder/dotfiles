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
