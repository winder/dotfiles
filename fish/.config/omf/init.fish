if status --is-interactive
  set -g fish_user_abbreviations
  abbr gco git checkout
  abbr gb git checkout -b
  abbr vi nvim
  abbr vim nvim
  abbr cat 'cat -v'
  abbr ag rg
  abbr src 'cd ~/code/'
end

# aws_staging_login will set env variables for an AWS session
function aws_staging_login
    aws sso login --profile staging
    aws s3 ls --profile staging

    set cache_file (find ~/.aws/cli/cache -type f -name '*.json' -print0 | xargs -0 ls -t 2>/dev/null | head -n 1)

    if test -n "$cache_file" -a -f "$cache_file"
        set -gx AWS_ACCESS_KEY_ID (jq -r '.Credentials.AccessKeyId' "$cache_file")
        set -gx AWS_SECRET_ACCESS_KEY (jq -r '.Credentials.SecretAccessKey' "$cache_file")
        set -gx AWS_SESSION_TOKEN (jq -r '.Credentials.SessionToken' "$cache_file")
        echo "AWS credentials exported."
    else
        echo "No AWS credentials cache file found."
    end
end

set -g theme_date_timezone America/New_York

set -gx PATH $HOME/.local/bin $PATH 
set -gx PATH $PATH /opt/java/jdk-13+33/bin
set -gx PATH $PATH ~/scripts

# Add local binaries to path
set -gx PATH $PATH ~/.local/bin/

# java

# graalvm
#set -gx GRAALVM_HOME /opt/java/graal/graalvm-ce-java11-20.2.0/
#set -gx JAVA_HOME $GRAALVM_HOME


set -gx JAVA_HOME /opt/java/jdk-23.0.1
set -gx PATH $JAVA_HOME/bin $PATH

# Add rust binaries
set -gx PATH $HOME/.cargo/bin $PATH

source ~/.secrets.fish
# to use the starship prompt...
# starship init fish | source

set -gx PATH $PATH /opt/goland/cur/bin

# Chainlink things
#if test -S /tmp/rustica.socket
  set -gx SSH_AUTH_SOCK /tmp/rustica.socket
#end

# pnpm
set -gx PNPM_HOME "/home/wwinder/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

set -gx QMK_HOME "/home/wwinder/code/qmk_firmware"
#set -gx CL_DATABASE_URL "postgresql://postgres:thispasswordislongenough@localhost:5432/chainlink_test?sslmode=disable"

# golang
set -gx GOROOT /opt/go/cur
set -gx GOPATH ~/go
set -gx PATH $PATH $GOROOT/bin $GOPATH/bin

# zig
set -gx PATH $PATH /opt/zig/cur

# Add solana cli
set -gx PATH $PATH "/home/wwinder/.local/share/solana/install/active_release/bin"

# Docker socket
# docker-desktop
#set -gx DOCKER_HOST unix:///home/wwinder/.docker/desktop/docker.sock
# docker engine
set -gx DOCKER_HOST unix:///var/run/docker.sock

set -gx PATH $PATH /opt/zig/cur
