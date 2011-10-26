Tests = require './tests'
assert = require 'assert'
helper = require('./tests').helper()

require('../src/hubot/scripts/code-review') helper

danger = Tests.danger helper, (req, res, url) ->
  
tests = [
  (msg) -> assert.equal 'Thanks, you will be part of code review today.', msg
  (msg) -> assert.equal 'You are already on my list.', msg
  (msg) -> assert.equal "You've been removed from today's code review.", msg
  (msg) -> assert.equal "Nobody needs code review. Get to work!", msg
  (msg) -> assert.equal 'Thanks, you will be part of code review today.', msg
  (msg) -> assert.equal 'Awaiting code review: [1]', msg
  (msg) -> assert.equal 'Need at least two people for code review!', msg
]

danger.start tests, ->
  helper.receive 'Hubot: haz'
  helper.receive 'Hubot: haz'
  helper.receive 'Hubot: nohaz'
  helper.receive 'Hubot: whohaz'
  helper.receive 'Hubot: haz'
  helper.receive 'Hubot: whohaz'
  helper.receive 'Hubot: pairup'
