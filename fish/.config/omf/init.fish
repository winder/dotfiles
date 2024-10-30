if status --is-interactive
  set -g fish_user_abbreviations
  abbr vi nvim
  abbr vim nvim
  abbr cat 'cat -v'
  abbr ag rg
  abbr src 'cd ~/chainlink/'
  abbr ws  'cd ~/chainlink/ccip-workspace'
end

set -g theme_date_timezone America/New_York

set -gx PATH $PATH /opt/java/jdk-13+33/bin
set -gx PATH $PATH ~/scripts

# Add local binaries to path
set -gx PATH $PATH ~/.local/bin/

# java

# graalvm
#set -gx GRAALVM_HOME /opt/java/graal/graalvm-ce-java11-20.2.0/
#set -gx JAVA_HOME $GRAALVM_HOME


#set -gx JAVA_HOME /opt/java/jdk1.8.0_202
#set -gx JAVA_HOME /opt/java/openjdk-11.0.2
#set -gx JAVA_HOME /opt/java/jdk-11.0.8+10
#set -gx JAVA_HOME /opt/java/jdk-12.0.2+10
#set -gx JAVA_HOME /opt/java/jdk-13+33
#set -gx JAVA_HOME /opt/java/adopt-openj9-14.0.2
#set -gx JAVA_HOME /opt/java/jdk-15+36
set -gx JAVA_HOME /opt/java/jdk-16.0.2+7
set -gx PATH $JAVA_HOME/bin $PATH

set -gx PATH /opt/java/gradle-7.1.1/bin $JAVA_HOME/bin $PATH

# Add rust binaries
set -gx PATH $HOME/.cargo/bin $PATH

source ~/.secrets.fish
# to use the starship prompt...
# starship init fish | source

set -gx PATH $PATH /opt/goland/cur/bin

# Chainlink things
set -gx SSH_AUTH_SOCK /tmp/rustica.socket

# pnpm
set -gx PNPM_HOME "/home/wwinder/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

set -gx QMK_HOME "/home/wwinder/code/qmk_firmware"
set -gx CL_DATABASE_URL "postgresql://postgres:thispasswordislongenough@localhost:5432/chainlink_test?sslmode=disable"

source ~/.asdf/asdf.fish

#set -gx GOROOT /opt/go/cur
#set -gx GOPATH ~/go
#set -gx PATH $PATH $GOROOT/bin $GOPATH/bin
