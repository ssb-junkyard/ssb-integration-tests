
var crypto = require('crypto')
var ssbKeys = require('ssb-keys')
function hash (h) {
  return crypto.createHash('sha256').update(''+h).digest()
}

console.log(JSON.stringify(
  ssbKeys.generate(null, hash(process.argv[2])), null, 2
))









