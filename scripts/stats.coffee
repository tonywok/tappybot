# Display tappy stats
#
# stats - display recent stats

http = require 'http'

class DataImporter
  constructor: (@msg) ->

  get_json: (url_options, hollaback) ->
    http.get(url_options, (response) ->
      buffer = ''
      response.on "data", (chunk) ->
        buffer += chunk
      response.on "end", ->
        data = JSON.parse buffer
        hollaback null, data
    ).on 'error', (e)->
      hollaback e

  summary: ->
    self = @
    options =
      host: 'tapinator.agrieser.net'
      port: 80
      path: '/thuds/stats/recent'
    this.get_json options, (error, data) ->
      if error
        self.msg.send "Error retrieving data"
      else
        thuds = data.thuds
        message = "Thuds:\n"
        message += "  today:      #{thuds.this_day}\n"
        message += "  this week:  #{thuds.this_week}\n"
        message += "  this month: #{thuds.this_month}\n"
        self.msg.send message

module.exports = (robot) ->
  robot.respond /stats$/i, (msg) ->
    new DataImporter(msg).summary()
