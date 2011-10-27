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
  helper.receive 'helper: qadd 123'
  helper.receive 'helper: qadd 125'
  helper.receive 'helper: qrm'
  helper.receive 'helper: qrm'
  helper.receive 'helper: qadd 123'
  helper.receive 'helper: qadd 456'
  helper.receive 'helper: qadd 789'
  helper.receive 'helper: qdelay 123'
  helper.receive 'helper: qdelay 789'
  helper.receive 'helper: qnext 789'
  helper.receive 'helper: qdelay 999'
  helper.receive 'helper: qls'

