
#! /bin/bash

# initialize the sbot with a given seed
# load data from deterministically generated messages

# initialize seed_index net_port ws_port bin_path

initialize () {
  # path is prefixed with .test_ so you can't accidentially pass
  rm -rf ~/.test_$appname
  mkdir ~/.test_$appname
  node seed.js $1 > ~/.test_$appname/secret
  echo '{"port": '$2', "ws":{"port":'$3'}}' > ~/.test_$appname/config
}

server () {
  ssb_appname=test_$appname $cmd server &
  echo $! > ~/.test_$appname/pid
  sleep 1
}

client () {
  ssb_appname=test_$appname $cmd "$@"
}

server_close () {
  silent kill `cat ~/.test_$appname/pid` || true
}

server_wait () {
  ssb_appname=test_$appname node wait.js
}

silent () {
  "$@" 2> /dev/null
}

assert_files_equal () {
  shasum $1 $2
  if ( cmp "$1" "$2" )
  then
    echo ok N $3
  else
    echo not ok N $3
  fi

}

if ([ "$0" = "$BASH_SOURCE" ] || ! [ -n "$BASH_SOURCE" ]);
then
  "$@"
fi



