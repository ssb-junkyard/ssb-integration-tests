var pull = require('pull-stream')
var toPull = require('stream-to-pull-stream')

pull(
  toPull.source(process.stdin),
  pull.collect(function (err, value) {
    value =
      JSON.parse(Buffer.concat(value).toString())
    value
      [process.argv[2]]
      .forEach(function (e) {
        console.log(e)
      })
  })
)
