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

initialize 0 8009 8990
node generate.js > ./tmp/input.json
server

ssb_appname=test_$appname node write.js < ./tmp/input.json

output () {
  server_wait
  client createLogStream --no-keys > ./tmp/output$1.json
  client friends.hops --hops 100 | node cannonical.js > ./tmp/hops$1.json
  client links --dest '@' > ./tmp/links$1.json
  client links --dest '%' > ./tmp/links_msg$1.json
}

output 1

echo
echo ----
echo

server_close

assert_files_equal ./tmp/output.json ./tmp/input.json 'output.json equals input.json'

for cmd2 in ${@:2} ;
do
  _cmd=$cmd
  if [[ "$_cmd" != "$cmd2" ]];
  then
    echo
    echo ---
    echo

    cmd="$cmd2"
    echo "testing:" $cmd
    server
#    time server_wait #sometimes it chooses to rebuild indexes
#    client createLogStream --no-keys > ./tmp/output2.json
#    client friends.hops --hops 100 | node cannonical.js > ./tmp/hops2.json
#    client links --dest '@' > ./tmp/links2.json
#    client links --dest '%' > ./tmp/links_msg2.json

    output 2

    silent server_close

    echo
    echo

    assert_files_equal ./tmp/output2.json ./tmp/input.json 'output2.json equals input.json'
    assert_files_equal ./tmp/hops2.json ./tmp/hops1.json 'hops2.json equals hops1.json'
    assert_files_equal ./tmp/links2.json ./tmp/links1.json 'links2.json equals links1.json'
    assert_files_equal ./tmp/links_msg2.json ./tmp/links_msg1.json 'links_msg2.json equals links_msg1.json'

    echo
    echo ---
    echo

  fi
done

