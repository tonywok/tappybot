# Who is Mike Jones?

responses = [
  "WHO?",
  "281-330-8004"
]

module.exports = (robot) ->
  robot.hear /(mike|matt) jones/i, (msg) ->
    msg.send msg.random responses

  robot.hear /who\?$/i, (msg) ->
    msg.send "MIKE JONES!"
