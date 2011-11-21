# Implement the die command (since people keep trying to use it)

divide_by_zero_images = [
  "http://1.bp.blogspot.com/-BKGU4DuZg8M/TkOT3DrAvNI/AAAAAAAAARY/M48dsQZKBX8/s1600/divide-by-zero.jpg"
]

response = (sides, number) ->
  "Rolling a #{sides} sided die...#{number}"

roll = (sides) ->
  1 + Math.floor(Math.random() * sides)

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
  "Congrats #{winners(initiatives)}! You win!\n\n#{summary}"

module.exports = (robot) ->
  robot.respond /die$/i, (msg) ->
    number_of_sides = 6
    msg.send response(number_of_sides, roll(number_of_sides))

  robot.respond /die (\d+)$/i, (msg) ->
    number_of_sides = parseInt(msg.match[1])
    if number_of_sides > 0
      msg.send response(number_of_sides, roll(number_of_sides))
    else
      msg.send msg.random divide_by_zero_images

  robot.respond /((roll off)|(roll initiative(s)?))$/i, (msg) ->
    initiatives = []
    users = robot.brain.data.users
    edgecase = (user for key, user of users)
    initiatives.push(roll_initiative(edgecaser)) for edgecaser in edgecase
    msg.send format(initiatives)
