# A way to make tappy be quiet
#
# shutup - Make tappy be quiet for an hour
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
  TIMEOUT = 1 * 60 * 60 * 10000
  timer_id = null
  robot.brain.data.quiet_time = false

  start_quiet_time = ->
    robot.brain.data.quiet_time = true
    timer_id = setTimeout (->
      end_quiet_time()
    ), TIMEOUT

  end_quiet_time = ->
    clearTimeout(timer_id)
    robot.brain.data.quiet_time = false

  robot.respond /shutup$/i, (msg) ->
    if !robot.brain.data.quiet_time
      start_quiet_time()
      msg.send "Fine. " + msg.random shutup_responses(msg.message.user)

  robot.respond /come back$/, (msg) ->
    if robot.brain.data.quiet_time
      end_quiet_time()
      msg.send "I'm back!"
    else
      msg.send "I'm still around!"
