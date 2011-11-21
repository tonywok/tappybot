http = require "http"
url  = require "url"

module.exports = (robot) ->
  TIMEOUT = 10 * 60 * 1000
  START_HOUR = 8
  END_HOUR = 18

  robot.brain.data.last_thud_time ||= 0

  queue_thud = ->
    last_thud_time = robot.brain.data.last_thud_time
    current_date = new Date
    if ((current_date.getTime() - last_thud_time) > TIMEOUT)
      hour = current_date.getHours()
      if hour >= START_HOUR && hour <= END_HOUR
        robot.brain.data.last_thud_time = current_date.getTime()
        robot.brain.save()
        send_thud()

  send_thud = ->
    robot.adapter.bot.rooms.forEach (room_id) ->
      user = {room: room_id}
      robot.adapter.send user, "THUD!"

  listen_port = process.env.HUBOT_TAP_LISTEN_PORT
  server = http.createServer (request, response) ->
    url_parts = url.parse(request.url)
    if url_parts.pathname == '/'
      response.writeHead(200, {'Content-Type': 'text/plain'})
      response.end()
      if !robot.brain.data.quiet_time
        queue_thud()

  server.listen(listen_port, "localhost")
