#! /bin/bash

# apis used: createWriteStream progress createLogStream
# also must understand minimist style argument parsing
# and rc style configuration loading.
# (uses a node script to wait for progress and call createWriteStream
#   wanted to compare against legacy versions of scuttlebot
#   so couldn't add apis to improve testability)

cmd=$1
appname=LOAD

. ./scripts/init.sh

# todo: preserve files for all tests
rm  -rf ./tmp
mkdir ./tmp

#set -e

server_close

output () {
  server_wait
  version=`client version`
  mkdir ./tmp/$version
  client whoami > ./tmp/$version/whoami.json
  client createLogStream --no-keys > ./tmp/$version/log.json
  client friends.hops --hops 100 | node cannonical.js > ./tmp/$version/hops.json
  client links --dest '@' > ./tmp/$version/links.json
  client links --dest '%' > ./tmp/$version/links_msg.json
  client latest > ./tmp/$version/latest.json
  shasum ./tmp/$version/*
}

#output 1

#echo
#echo ----
#echo

#server_close

#assert_files_equal ./tmp/output.json ./tmp/input.json 'output.json equals input.json'

node generate.js > ./tmp/input.json

for cmd2 in ${@:1} ;
do
  cmd="$cmd2"

  initialize 0 8009 8990
  server
  server_wait

  time ssb_appname=test_$appname node write.js < ./tmp/input.json

  echo "testing:" $cmd

  output

  silent server_close

  echo
  echo ---
  echo


done

