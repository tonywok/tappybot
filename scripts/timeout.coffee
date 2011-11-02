# A way to put tappy on time out
#
# shutup - Put tappy on timeout for 10 minutes
#
# come back - Bring tappy back

shutup_responses = (user) ->
  [
    "I'll find another window to tap on.",
    "I'll go work somewhere I'm appreciated.",
    "Watch yourself on the way to your car #{user.name}, my beak is extra sharp today.",
    "I'll just take a crap on #{user.name}'s car instead."
  ]

module.exports = (robot) ->
  TIMEOUT = 10 * 60 * 10000
  robot.brain.data.timeout = null

  start_timeout = ->
    robot.brain.data.timeout = setTimeout (->
      end_timeout()
    ), TIMEOUT

  end_timeout = ->
    clearTimeout(robot.brain.data.timeout)
    robot.brain.data.timeout = null

  robot.respond /shutup$/i, (msg) ->
    if robot.brain.data.timeout?
      msg.send "I'm already on timeout. Leave me alone."
    else
      start_timeout()
      msg.send "Fine. " + msg.random shutup_responses(msg.message.user)

  robot.respond /come back$/, (msg) ->
    if robot.brain.data.timeout?
      end_timeout()
      msg.send "I'm back!"
    else
      msg.send "I didn't go away"
