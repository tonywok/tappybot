http = require "http"
url  = require "url"

module.exports = (robot) ->
  TIMEOUT = 1 * 60 * 1000
  rate_limit = null
  thud_count = 0

  queue_thud = ->
    if rate_limit?
      thud_count++
    else
      send_thud()
      rate_limit = setTimeout (->
        end_ratelimit()
      ), TIMEOUT

  end_ratelimit = ->
    rate_limit = null
    if thud_count > 1
      send_thud(thud_count)
      thud_count = 0

  send_thud = (count) ->
    unless robot.brain.data.timeout?
      robot.bot.rooms.forEach (room_id) ->
        user = {room: room_id}
        if count?
          robot.send user, "THUD! x#{count}"
        else
          robot.send user, "THUD!"

  listen_port = process.env.HUBOT_TAP_LISTEN_PORT
  server = http.createServer (request, response) ->
    url_parts = url.parse(request.url)
    if url_parts.pathname == '/'
      response.writeHead(200, {'Content-Type': 'text/plain'})
      response.end()
      unless robot.brain.data.timeout?
        queue_thud()

  server.listen(listen_port, "localhost")
