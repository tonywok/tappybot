# Cute pictures
#
# aww - post a cute picture

aww = (msg) ->
  msg
    .http('http://imgur.com/r/aww.json')
      .get() (err, res, body) ->
        images = JSON.parse(body)
        images = images.gallery
        image  = msg.random images
        msg.send "http://i.imgur.com/#{image.hash}#{image.ext}"

module.exports = (robot) ->
  robot.respond /aw(w+)$/i, (msg) ->
    if !robot.brain.data.quiet_time
      aww(msg)
