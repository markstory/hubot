# Register people for code review.
#
# haz - Register for code review pairing
# nohaz - Un-register for code review paring
# whohaz - Find out who is registered.
# pairup - Create code review partners.


module.exports = (robot) ->
  robot.brain.data.codereview = robot.brain.data.codereview || []
  people = robot.brain.data.codereview

  robot.respond /\bhaz$/i, (msg) ->
    user = msg.user.id
    if user in people
      msg.reply 'You are already on my list'
    else
      people.push user
      msg.reply 'Thanks, you will be part of code review today.'

  robot.respond /nohaz$/i, (msg) ->
    user = msg.user.id

    if user in people
      msg.reply "You've been removed from today's code review."
    else
      msg.reply "You're not in the list silly"

  robot.respond /whohaz$/i, (msg) ->
    if people.length == 0
      msg.send 'Nobody needs code review. Get to work!'
    else
      msg.send "Awaiting code review: [#{people.join(',')}]"

  robot.respond /\bpairup$/i, (msg) ->
    if people.length < 2
      return msg.send 'Need at least two people for code review!'
    who = people
    people = []
    who.sort () -> return 0.5 - Math.random()

    text = [
      'Code Review Pairs',
      '-----------------'
    ]
    pair = ''
    if who.length % 2 == 1
      loner = who.pop
      pair += "#{loner}, "

    num = who.length
    text.push "#{who[i]} and #{who[i + 1]}" while num -= 2

    msg.send text.join('\n')

