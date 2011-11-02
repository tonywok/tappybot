# Utility commands surrounding Hubot uptime.
module.exports = (robot) ->
  robot.respond /PING$/i, (msg) ->
    msg.send "PONG"
