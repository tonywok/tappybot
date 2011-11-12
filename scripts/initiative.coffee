roll_initiative = (edgecaser) ->
  score = 1 + Math.floor(Math.random() * 20)
  { name: edgecaser.name, score: score }

winners = (initiatives) ->
  max_score = initiatives[0].score
  names = (roll.name for roll in initiatives when roll.score == max_score)
  names.join(", ")

format_summary = (initiatives) ->
  lines = ("#{roll.name} rolled a #{roll.score}" for roll in initiatives)
  lines.join("\n")

format = (initiatives) ->
  initiatives.sort((a, b) -> b.score - a.score)
  summary = format_summary(initiatives)
  "#{summary}\n\nCongrats #{winners(initiatives)}! You win!"

module.exports = (robot) ->
  robot.respond /((roll off)|(roll initiative(s)?))$/i, (msg) ->
    initiatives = []
    users = robot.brain.data.users
    edgecase = (user for key, user of users)
    initiatives.push(roll_initiative(edgecaser)) for edgecaser in edgecase
    msg.send format(initiatives)
