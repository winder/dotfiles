if status --is-interactive
  set -g fish_user_abbreviations
  abbr vi nvim
  abbr vim nvim
  abbr ag rg

  abbr gosrc 'cd ~/go/src/github.com/algorand/go-algorand/'
  abbr src 'cd ~/algorand/'
end

set -gx ALGORAND_DATA ~/.algorand
set -gx GOROOT /opt/go/go
set -gx GOPATH ~/go
set -gx PATH $PATH $GOROOT/bin $GOPATH/bin
