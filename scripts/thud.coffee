http = require "http"
url  = require "url"

module.exports = (robot) ->
  TIMEOUT = 1 * 60 * 60 * 1000
  START_HOUR = 8
  END_HOUR = 18
  rate_limit = false

  queue_thud = ->
    if !rate_limit
      rate_limit = true
      send_thud()
      setTimeout (->
        rate_limit = false
      ), TIMEOUT

  send_thud = ->
    hour = new Date().getHours()
    if hour >= START_HOUR && hour <= END_HOUR
      robot.bot.rooms.forEach (room_id) ->
        user = {room: room_id}
        robot.send user, "THUD!"

  listen_port = process.env.HUBOT_TAP_LISTEN_PORT
  server = http.createServer (request, response) ->
    url_parts = url.parse(request.url)
    if url_parts.pathname == '/'
      response.writeHead(200, {'Content-Type': 'text/plain'})
      response.end()
      if !robot.brain.data.quiet_time
        queue_thud()

  server.listen(listen_port, "localhost")
