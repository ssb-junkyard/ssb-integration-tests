
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
  var roots = []
  var state = v.initial()
  var time = +new Date('2018-05-23T00:33:05.480Z')
  for(var i = 0; i < peers.length; i++) {
    var _peer = peers[~~(Math.pow(mt.random(), 2)*i)]
    var peer = peers[i]
    state = v.appendNew(state, null, _peer, {
      type: 'contact', contact: peer.id,
      following: true
    }, time+=1000)
    state = v.appendNew(state, null, peer, {
      type: 'contact', contact: _peer.id,
      following: true
    }, time+=1000)
    for(var j = 0; j < peers.length/n; j++) {
      state = v.appendNew(state, null, peer, {
        type: 'test', date: 'hello world:' + hash(j).toString('base64'),
        root:
          mt.random() < 0.3 ? undefined : roots[~~(mt.random()*roots.length)],
        value: j
      }, time+=1000)

      var msg = state.queue[state.queue.length - 1]
      if(!msg.content.root)
        roots.push(state.feeds[msg.author].id)
    }
  }
  return state
}

network(createFeeds(1000), 100).queue.forEach(function (e) {
  console.log(JSON.stringify(e, null, 2)+'\n')
})



