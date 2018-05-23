

var n = 0
;(function retry () {
  require('ssb-client')(function (err, sbot) {
    if(++n > 5) throw new Error('failed to connect')
    if(err) return setTimeout(retry, 500*n)
    ;(function next () {
      sbot.progress(function (err, prog) {
        if(prog) {
          var total = 0
          for(var k in prog)
             total += prog[k].target - prog[k].current
          if(total) setTimeout(next, 200)
          else sbot.close(true)
        }
      })
    })()
  })

})()
