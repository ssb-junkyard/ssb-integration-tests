var pull = require('pull-stream')
var toPull = require('stream-to-pull-stream')

function sort (obj) {
  if(Array.isArray(obj)) return obj.map(sort)

  //skip anything not already an object
  if(!(obj && 'object' == typeof obj))
    return obj

  var _obj = {}
  var keys = Object.keys(obj)
  keys.sort().forEach(function (k) {
    _obj[k] = sort(obj[k])
  })
  return _obj
}

pull(
  toPull.source(process.stdin),
  pull.collect(function (err, value) {
    console.log(JSON.stringify(sort(JSON.parse(
      Buffer.concat(value).toString()
    )), null, 2))
  })
)






