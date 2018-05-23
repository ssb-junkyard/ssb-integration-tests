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

set -e

server_close

initialize 0 8009 8990
node generate.js > ./tmp/input.json
server

ssb_appname=test_$appname node write.js < ./tmp/input.json

server_wait
client createLogStream --no-keys > ./tmp/output.json

echo
echo ----
echo

server_close

assert_files_equal ./tmp/output.json ./tmp/input.json 'output.json equals input.json'

cmd=$2
server
client createLogStream --no-keys > ./tmp/output2.json

server_close

echo
echo ---
echo

assert_files_equal ./tmp/output2.json ./tmp/input.json 'output2.json equals input.json'



