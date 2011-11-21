actions = [
  'investigate hammock driven development'
  'refactor javascript'
  'drink heavily'
  'learn clojure'
  'meta program tomorrows code'
  'convert html5 page to flash'
  'migrate the database to oracle'
  'remove support for all browsers except IE'
  'tap tap THUD tap'
  'not let Felix play music'
  'delete cucumber tests'
  'convert tests from rspec to shoulda'
  'make a new tappy script'
  'post animated gifs in ewatercooler'
  'write a new dsl on top of my dsl'
  'wait for an AS 400 to return a result'
  'practice doing it live'
  'force push my interactive rebase'
  'find my stapler'
  'fax the chipotle order'
  'figure out who mike jones really is'
  'sprint to the parking lot for my stand up'
  'invent new acronyms'
  'prove that CSS is turing complete'
  'unit test my test suite'
  'monkey patch core libraries'
  'generate a scaffold for object'
  'undefined' # why not?
]

reasons = [
  'provide value to the client'
  'further improve the relationship with the client'
  'grow as a developer'
  'maintain mental health'
  'meet the deadline'
  'fulfill my daily commitment'
  'fulfill my destiny'
  'improve my chance at beating Ken in ping-pong'
  'improve my codes'
  'avoid team mutiny'
  'increase my mitochlorian count'
  'figure out the meaning of life'
  'in order to prove P = NP'
  'undefined' # why not?
]


module.exports = (robot) ->
  robot.respond /daily commitment$/i, (msg) ->
    commitment = "Today I will #{msg.random actions} in order to #{msg.random reasons}"
    msg.respond commitment
