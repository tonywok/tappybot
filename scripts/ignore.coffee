_ = require 'underscore'

IGNORE_TIMEOUT = 15 * 60 * 1000
INTERVAL = 60 * 1000

module.exports = (robot) ->
  robot.brain.data.ignore_list ||= []

  update = ->
    ignore_list = robot.brain.data.ignore_list
    notice_ids = []
    for user in ignore_list
      user.time -= INTERVAL
      if user.time < 0
        notice_ids.push(user.id)
    for id in notice_ids
      notice(id)
    robot.brain.save()

  setInterval update, INTERVAL

  ids = ->
    _.pluck robot.brain.data.ignore_list, 'id'

  orig_receive = robot.receive
  robot.receive = (message) ->
    if ! _.include ids(), message.user.id
      orig_receive.call(robot, message)

  notice = (user_id, hollaback) ->
    idx = _.indexOf ids(), user_id
    if idx >= 0
      robot.brain.data.ignore_list.splice(idx, 1)
      robot.brain.save()
      hollaback() if hollaback

  ignore = (user_id, hollaback) ->
    robot.brain.data.ignore_list.push({id: user_id, time: IGNORE_TIMEOUT})
    robot.brain.save()
    hollaback() if hollaback

  robot.respond /ignore (\d+)$/i, (msg) ->
    user_id = parseInt(msg.match[1])
    user = _.find robot.brain.data.users, (user) -> user.id == user_id
    return unless user
    if _.include ids(), user.id
      msg.send "Already ignoring #{user.name}"
    else
      ignore user.id, ->
        msg.send "Ignoring #{user.name} for #{IGNORE_TIMEOUT / (1000 * 60)} minutes"

  robot.respond /notice (\d+)$/i, (msg) ->
    user_id = parseInt(msg.match[1])
    user = _.find robot.brain.data.users, (user) -> user.id == user_id
    return unless user
    if _.include ids(), user.id
      notice user.id, ->
        msg.send "Noticing #{user.name}"
    else
      msg.send "#{user.name} is not being ignored"

  robot.respond /ignores$/i, (msg) ->
    response = ""
    ignore_list = robot.brain.data.ignore_list
    if ignore_list.length > 0
      for list_user in ignore_list
        ignore_user = _.find robot.brain.data.users, (user) -> user.id == list_user.id
        response += "#{ignore_user.name}: #{Math.round(list_user.time / (60 * 1000))}"
      msg.send response
    else
      msg.send "No ignores"
