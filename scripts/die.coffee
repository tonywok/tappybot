# Implement the die command (since people keep trying to use it)

divide_by_zero_images = [
  "http://1.bp.blogspot.com/-BKGU4DuZg8M/TkOT3DrAvNI/AAAAAAAAARY/M48dsQZKBX8/s1600/divide-by-zero.jpg"
]

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
    if number_of_sides > 0
      msg.send response(number_of_sides, roll(number_of_sides))
    else
      msg.send msg.random divide_by_zero_images
