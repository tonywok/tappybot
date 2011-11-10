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
  INTERVAL = 60 * 1000
  TIMEOUT = 60 * 60 * 1000

  robot.brain.data.quiet_time ||= false
  robot.brain.data.quiet_time_remaining ||= 0

  countdown = ->
    if robot.brain.data.quiet_time_remaining > 0
      robot.brain.data.quiet_time_remaining -= INTERVAL
      robot.brain.save()
    else if robot.brain.data.quiet_time
      robot.brain.data.quiet_time = false
      robot.brain.save()

  setInterval countdown, INTERVAL

  start_quiet_time = ->
    robot.brain.data.quiet_time = true
    robot.brain.data.quiet_time_remaining = TIMEOUT
    robot.brain.save()

  end_quiet_time = ->
    robot.brain.data.quiet_time = false
    robot.brain.data.quiet_time_remaining = 0
    robot.brain.save()

  remaining = ->
    robot.brain.data.quiet_time_remaining / 1000

  robot.respond /shutup$/i, (msg) ->
    if !robot.brain.data.quiet_time
      start_quiet_time()
      msg.send "Fine. " + msg.random shutup_responses(msg.message.user)
    else
      msg.send "Already on timeout for another #{remaining()} seconds"

  robot.respond /come back$/, (msg) ->
    if robot.brain.data.quiet_time
      end_quiet_time()
      msg.send "I'm back!"
    else
      msg.send "I'm still around!"
