# Get some weather action!
#
# weather <city> - Get the weather for a location
# forecast <city> - Get the forecast for a location
JsDom = require 'jsdom'

module.exports = (robot) ->
  robot.respond /weather(?: me)?\s(.*)/, (msg) ->
    msg.http('http://www.google.com/ig/api')
      .query(weather: location)
      .get() (err, res, body) ->
        try
          body = getDom body
        catch err
          return msg.send 'Could not fetch weather data :('
  
        strings = []
        for element in body.getElementsByTagName('forecast_conditions')
          day = element.getElementsByTagName('day_of_week')[0].getAttribute('data');
          low = element.getElementsByTagName('low')[0].getAttribute('data');
          high = element.getElementsByTagName('high')[0].getAttribute('data');
          condition = element.getElementsByTagName('condition')[0].getAttribute('data');
          strings.push "#{day} #{condition} high of: #{convertTemp(high)} low of: #{convertTemp(low)}"

        msg.send strings

  robot.respond /forecast(?: me)?\s(.*)/, (msg) ->



  getDom = (xml) ->
    body = JsDom.jsdom(xml)
    throw Error('No xml') if body.getElementsByTagName('weather')[0].childNodes.length == 0
    return body

  convertTemp = (faren) ->
    return ((5 / 9) * (faren - 32)).toFixed 0
