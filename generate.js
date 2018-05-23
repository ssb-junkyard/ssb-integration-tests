
var v = require('ssb-validate')
var crypto = require('crypto')
var ssbKeys = require('ssb-keys')
var timestamp = require('monotonic-timestamp')
var RNG = require('rng')

var mt = new RNG.MT(0)

function hash (h) {
  return crypto.createHash('sha256').update(''+h).digest()
}

function createFeeds (n) {
  var feeds = []
  for(var i = 0; i < n; i++)
    feeds.push(ssbKeys.generate(null, hash(i)))
  return feeds
}

function network (peers, n) {
  var state = v.initial()
  var time = +new Date('2018-05-23T00:33:05.480Z')
  for(var i = 0; i < peers.length; i++) {
    var _peer = peers[~~(mt.random()*i)]
    var peer = peers[i]
    state = v.appendNew(state, null, _peer, {
      type: 'contact', contact: peer.id,
      following: true
    }, time+=1000)
    for(var j = 0; j < peers.length/n; j++) {
      state = v.appendNew(state, null, peer, {
        type: 'test', date: 'hello world:' + hash(j).toString('base64'),
        value: j
      }, time+=1000)
    }
  }
  return state
}

console.log(JSON.stringify(network(createFeeds(1000), 100).queue, null, 2))

