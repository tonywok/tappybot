module.exports = (robot) ->
  robot.respond /show users$/i, (msg) ->
    response = ""
    for own key, user of robot.brain.data.users
      response += "#{user.id} #{user.name}\n"
    msg.send response
