# vim:set ft=sh et:

alias gosrc='cd ~/go/src/github.com/algorand/go-algorand/'
alias src='cd ~/algorand/'

export ALGORAND_DATA=~/.algorand
export ALGOD_UPDATER_SKIP_BACKUP=1
export S3_RELEASE_BUCKET=algorand-releases
#export S3_RELEASE_BUCKET=algorand-internal

b64tojson() {
    echo "$1" | base64 -d | msgpacktool -d
}

algossh() {
  echo "ssh -i ~/.ssh/algo_shared.pem ubuntu@$1"
  ssh -i ~/.ssh/algo_shared.pem "ubuntu@$1"
}

newAlgodDataDir() {
  NEW_ALGOD_DATA_DIR=$(date '+%d-%b-%Y_%s')
  mkdir ~/algod_data/$NEW_ALGOD_DATA_DIR
  [ -e ~/.algorand ] && rm ~/.algorand
  $(ln -s ~/algod_data/$NEW_ALGOD_DATA_DIR ~/.algorand)
}
