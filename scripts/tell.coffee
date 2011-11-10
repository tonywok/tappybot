# Tell tappybot to send a user a message when present in the room
#
# tell '<user>' <message> - send <message> to <user> once they are next active

class UserMessage
  constructor: (@username, @robot) ->
    @storage = @robot.brain.data.tell_storage

  save: ->
    @robot.brain.save()

  add: (message) ->
    @storage[@username] ||= []
    @storage[@username].push(message)
    this.save()

  count: ->
    if @storage[@username]
      @storage[@username].length
    else
      0
  pop: (hollaback) ->
    if @storage[@username]
      message = @storage[@username].shift()
      if this.count() == 0
        delete @storage[@username]
      this.save()
      hollaback(message)


module.exports = (robot) ->
  robot.brain.data.tell_storage ||= {}

  robot.enter (msg) ->
    say_message(msg)

  robot.hear /./i, (msg) ->
    say_message(msg)

  robot.respond /tell '(.*?)' (.*)/i, (msg) ->
    user = msg.match[1] || 'undefined'
    message = msg.match[2]
    date = new Date()
    tell_message = user + ": " + msg.message.user.name + " @ " + date.toTimeString() + " said: " + message
    new UserMessage(user, robot).add(tell_message)
    msg.send "I'll let them know when I see them"

  say_message = (msg) ->
    username = msg.message.user.name
    usermessage = new UserMessage(username, robot)
    while usermessage.count() > 0
      usermessage.pop (tell_message) ->
        msg.send tell_message
