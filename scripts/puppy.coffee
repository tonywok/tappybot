# Get the puppy of the day

HtmlParser = require 'htmlparser'
Select     = require('soupselect').select

module.exports = (robot) ->
  robot.respond /puppy of the day$/i, (msg) ->
    msg.http('http://www.dailypuppy.com/')
      .get() (error, response, body) ->
        handler = new HtmlParser.DefaultHandler
        parser = new HtmlParser.Parser handler
        parser.parseComplete body
        img = Select handler.dom, ".daily_puppy a img"
        url = img[0].attribs.src
        msg.send url
