var pull = require('pull-stream')
var JSONDL = require('pull-json-doubleline')
var toPull = require('stream-to-pull-stream')
var paramap = require('pull-paramap')

;(function next () {
  require('ssb-client')(function (err, sbot) {

    function done (err) {
      if(err) throw err
      sbot.close()
    }

    if(err) setTimeout(next, 100)
    pull(
      toPull.source(process.stdin),
      JSONDL.parse(),
      //write to sbot, wether it supports createWriteStream or not
      paramap(function (e, cb) {
          sbot.add(e, cb)
        }, 128),
      pull.drain(null, done)
      )
  })
})()





















