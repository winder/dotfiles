if status --is-interactive
  set -g fish_user_abbreviations
  abbr vi nvim
  abbr vim nvim
  abbr ag rg

  abbr gosrc 'cd ~/go/src/github.com/algorand/go-algorand/'
  abbr src 'cd ~/algorand/'
end

set -g theme_date_timezone America/New_York

set -gx PATH $PATH /opt/java/jdk-13+33/bin
set -gx PATH $PATH ~/scripts

set -gx ALGORAND_DATA ~/.algorand
set -gx GOROOT /opt/go/go
set -gx GOPATH ~/go
set -gx PATH $PATH $GOROOT/bin $GOPATH/bin

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
set -gx JAVA_HOME /opt/java/jdk-15+36
set -gx PATH $JAVA_HOME/bin $PATH

source ~/.secrets.fish
# to use the starship prompt...
# starship init fish | source
