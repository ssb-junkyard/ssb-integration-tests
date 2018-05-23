

require('ssb-client')(function (err, sbot) {
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




