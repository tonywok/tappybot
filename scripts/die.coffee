# Implement the die command (since people keep trying to use it)

response = (sides, number) ->
  "Rolling a #{sides} sided die...#{number}"

roll = (sides) ->
  1 + Math.floor(Math.random() * sides)

module.exports = (robot) ->
  robot.respond /die$/i, (msg) ->
    number_of_sides = 6
    msg.send response(number_of_sides, roll(number_of_sides))

  robot.respond /die (\d+)$/i, (msg) ->
    number_of_sides = parseInt(msg.match[1])
    msg.send response(number_of_sides, roll(number_of_sides))
