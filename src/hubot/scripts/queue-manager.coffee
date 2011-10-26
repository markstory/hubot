# Manipulate the queue for releasing
#
# qadd <ticket> - Add a ticket to the end of queue
# qrm   - Shift a ticket from the queue.
# qls   - Display the queue.
# qnext <ticket> - Make the provided ticket first in the queue.
# qdelay <ticket> - Move the provided ticket to the end of the queue.

module.exports = (robot) ->
  # initialize the redis store.
  robot.brain.data.queuemanager = robot.brain.data.queuemanager || []
  queue = robot.brain.data.queuemanager

  robot.respond /qadd\s*(\d+)/, (msg) ->
    ticket = msg.match[1]
    queue.push ticket
    msg.send show()

  robot.respond /qrm/, (msg) ->
    queue.shift()
    msg.send show()

  robot.respond /qls/, (msg) ->
    msg.send show()

  robot.respond /qnext\s*(\d+)/, (msg) ->
    ticket = msg.match[1]
    index = queue.indexOf ticket
    queue.splice(index, 1) if index > -1
    queue.unshift ticket
    msg.send show()

  robot.respond /qdelay\s*(\d+)/, (msg) ->
    ticket = msg.match[1]
    index = queue.indexOf ticket
    return msg.send "#{ticket} not in the queue; did you mean qadd #{ticket}?" if index == -1
    queue.splice index, 1
    queue.push ticket
    msg.send show()

  show = ->
    return 'The queue is empty, well done!' if queue.length == 0
    return "The queue is: [#{queue.join(', ')}]"
