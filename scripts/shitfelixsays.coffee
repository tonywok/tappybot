pick_quote = (tweets) ->
  random          = Math.floor(Math.random() * tweets.length)
  random_newish   = Math.floor(Math.random() * random)
  shit_felix_said = tweets[random_newish]
  "\"#{shit_felix_said.text}\"  - Felix"

module.exports = (robot) ->
  robot.respond /(shitfelixsays|faylix)/i, (msg) ->
    msg.http('http://api.twitter.com/1/statuses/user_timeline.json')
      .query(screen_name: 'shitfelixsays')
      .get() (err, res, body) ->
        tweets = JSON.parse(body)
        quote  = pick_quote(tweets)
        msg.send quote
