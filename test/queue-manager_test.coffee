Tests = require './tests'
assert = require 'assert'
helper = require('./tests').helper()

require('../src/hubot/scripts/queue-manager') helper

danger = Tests.danger helper, (req, res, url) ->
  
tests = [
  (msg) -> assert.equal 'The queue is: [123]', msg
  (msg) -> assert.equal 'The queue is: [123, 125]', msg
  (msg) -> assert.equal 'The queue is: [125]', msg
  (msg) -> assert.equal 'The queue is empty, well done!', msg
  (msg) -> assert.equal 'The queue is: [123]', msg
  (msg) -> assert.equal 'The queue is: [123, 456]', msg
  (msg) -> assert.equal 'The queue is: [123, 456, 789]', msg
  (msg) -> assert.equal 'The queue is: [456, 789, 123]', msg
  (msg) -> assert.equal 'The queue is: [456, 123, 789]', msg
  (msg) -> assert.equal 'The queue is: [789, 456, 123]', msg
  (msg) -> assert.equal '999 not in the queue; did you mean qadd 999?', msg
  (msg) -> assert.equal 'The queue is: [789, 456, 123]', msg
]

danger.start tests, ->
  helper.receive 'Hubot: qadd 123'
  helper.receive 'Hubot: qadd 125'
  helper.receive 'Hubot: qrm'
  helper.receive 'Hubot: qrm'
  helper.receive 'Hubot: qadd 123'
  helper.receive 'Hubot: qadd 456'
  helper.receive 'Hubot: qadd 789'
  helper.receive 'Hubot: qdelay 123'
  helper.receive 'Hubot: qdelay 789'
  helper.receive 'Hubot: qnext 789'
  helper.receive 'Hubot: qdelay 999'
  helper.receive 'Hubot: qls'
