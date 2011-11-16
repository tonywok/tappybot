# A way to interact with the Google Images API.
#
# image me <query>    - The Original. Queries Google Images for <query> and returns a random top result.
# animate me <query>  - The same thing as `image me`, except adds a few parameters to try to return an animated GIF instead.
# <mustache_type> mustache me <url>   - Adds a mustache to the specified URL. Valid mustache types: handlebar|colonel|winfield.
# <mustache_type> mustache me <query> - Searches Google Images for the specified query and mustaches it. Valid mustache types: handlebar|colonel|winfield.
module.exports = (robot) ->
  robot.respond /(image|img)( me)? (.*)/i, (msg) ->
    imageMe msg, msg.match[3], (url) ->
      msg.send url

  robot.respond /animate me (.*)/i, (msg) ->
    imageMe msg, "animated #{msg.match[1]}", (url) ->
      msg.send url

  robot.respond /(\w*)? ?(?:mo?u)?sta(?:s|c)he?(?: me)? (.*)/i, (msg) ->
    imagery = msg.match[2]
    stache = msg.match[1]

    if imagery.match /^https?:\/\//i
      msg.send "#{mustachify(stache)}#{imagery}"
    else
      imageMe msg, imagery, (url) ->
        msg.send "#{mustachify(stache)}#{url}"

mustachify = (stache) ->
  stache = staches[stache] || 0
  "http://mustachify.me/#{stache}?src="

staches =
  handlebar:  0
  colonel:    1
  winfield:   2

imageMe = (msg, query, cb) ->
  msg.http('http://ajax.googleapis.com/ajax/services/search/images')
    .query(v: "1.0", rsz: '8', q: query)
    .get() (err, res, body) ->
      images = JSON.parse(body)
      images = images.responseData.results
      image  = msg.random images
      cb "#{image.unescapedUrl}#.png"

