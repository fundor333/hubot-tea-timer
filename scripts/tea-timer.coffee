# Description:
#   Hubot will handle your tea timer needs
#
# Commands:
#   hubot tea start <minute> - start a tea timer
#   hubot tea stop - stop a tea timer
#   hubot tea info - show info about the current tea timer
#   hubot tea mine - show info about all of my current tea timers
#   hubot tea all - show all the tea timers, everywhere
#   hubot tea help - return the allowed commands
#
# Configuration:
#   HUBOT_TEA_TIMER_EMOJI - set the tea timer emoji. default: `:tea:`
#
# Dependencies:
#   none
#
# Author:
#   fundor333

teaEmoji = process.env.HUBOT_TEA_TIMER_EMOJI or ':tea:'

timers = {}
botName = 'botName not set'
bot = null

help = [
  'tea start <minute> - start a tea timer for <minute>'
  'tea stop - stop a tea timer'
  'tea info - show info about the current tea timer'
  'tea mine - show info about all of my current tea timers'
  'tea all - show all the tea timers, everywhere'
  'tea help - return the allowed commands'
]


stringCompare = (a, b) ->
  return a.toLowerCase() is b

cleanUpTimer = (key, intervalId) ->
  #stop timer and remove the key from timers map
  clearInterval intervalId
  delete timers[key]

timeRemaining = (expectedStop) ->
  secsRemaining = Math.floor((expectedStop - Date.now())/1000)
  minutesRemaining = Math.ceil(secsRemaining/60)
  return "Less than #{minutesRemaining} min (#{secsRemaining} sec)" unless minutesRemaining is 1
  return "#{secsRemaining} sec" unless minutesRemaining isnt 1

teaTimerCallback = (key) ->
  userInfo = timers[key]

  if userInfo?
    cleanUpTimer key, userInfo.intervalId
    bot.messageRoom userInfo.room, "Hey #{userInfo.name}! Your #{teaEmoji} is done!"
  else
    console.log "WAT?!?!?"

stopTimer = (msg, userInfo) ->
  timer = timers[userInfo.key]

  if timer?
    msg.send "Stopping #{teaEmoji} timer for #{userInfo.name} in ##{userInfo.room}"
    cleanUpTimer userInfo.key, timer.intervalId
  else
    msg.send "No #{teaEmoji} timer exists for #{userInfo.name} in ##{userInfo.room}. Try `#{botName} tea start`"

showAllTimers = (msg, userInfo) ->
  keys = Object.keys timers

  if keys? and keys.length > 0
    deets = ("#{key}: " + timeRemaining(timers[key].expectedStop) + " remaining" for key in keys).join "\n* "
    msg.send "Here are all the #{teaEmoji} timers!\n\n* #{deets}"
  else
    msg.send "No #{teaEmoji} timers exist!. Try `#{botName} tea start`"

showMyTimers = (msg, userInfo) ->
  allKeys = Object.keys timers

  unless allKeys? and allKeys.length > 0
    msg.send "No #{teaEmoji} timers exist!. Try `#{botName} tea start`"
    return

  keys = allKeys.filter (key) -> return key if timers[key].name == userInfo.name

  if keys? and keys.length > 0
    deets = ("#{key}: " + timeRemaining(timers[key].expectedStop) + " remaining" for key in keys).join "\n* "
    msg.reply "Here are your #{teaEmoji} timers!\n\n* #{deets}"
  else
    msg.send "No #{teaEmoji} timers exist!. Try `#{botName} tea start`"

showTimerInfo = (msg, userInfo) ->
  timer = timers[userInfo.key]

  if timer?
    deets = timeRemaining(timer.expectedStop) + " remaining"
    msg.reply "Your #{teaEmoji} timer info: #{deets}"
  else
    msg.send "No #{teaEmoji} timers exist!. Try `#{botName} tea start`"

processCommands = (msg, cmd, cmdArgs) ->
  user = msg.message.user.name
  room = msg.message.user.room
  key = "#{user}_#{room}"
  userInfo =
    key: key
    name: user
    room: room

  if cmd and stringCompare cmd, 'help'
    deets =  ("#{botName} #{h}" for h in help).join '\n'
    msg.send "I came here to drink milk and start tea timers. And I've just finished my milk.\n\n#{deets}"
    return

  if cmd and stringCompare cmd, 'stop'
    stopTimer msg, userInfo
    return

  if cmd and stringCompare cmd, 'info'
    showTimerInfo msg, userInfo
    return

  if cmd and stringCompare cmd, 'mine'
    showMyTimers msg, userInfo
    return

  if cmd and stringCompare cmd, 'all'
    showAllTimers msg, userInfo
    return

  msg.send "I don't understand #{cmd}. Try `#{botName} tea help`"

startTimer = (msg, others) ->
  user = msg.message.user.name
  room = msg.message.user.room
  key = "#{user}_#{room}"
  userInfo =
    key: key
    name: user
    room: room

  timer = timers[userInfo.key]
  if others is null
    msg.send "You must insert a valid time"
    return
  time = Math.floor(others*60*1000)
  if timer?
    msg.send "#{teaEmoji} timer already started for #{userInfo.name} in ##{userInfo.room}. Try `#{botName} tea stop`"
  else
    msg.send "Starting #{teaEmoji} timer for #{others} minutes for #{userInfo.name} in ##{userInfo.room}"
    timers[userInfo.key] = userInfo
    intervalId = setInterval teaTimerCallback, time, userInfo.key
    timers[userInfo.key].intervalId = intervalId
    timers[userInfo.key].startTime = Date.now()
    timers[userInfo.key].expectedStop = timers[userInfo.key].startTime + time


module.exports = (robot) ->
  botName = robot.name
  bot = robot

  robot.respond /(all|stop|info|mine|help){1} (tea|timer|Té|:tea:){1}/i, (msg) ->
    cmd     = msg.match[1] or null
    cmdArgs = msg.match[2] or null

    processCommands msg, cmd, cmdArgs

  robot.respond /(tea timer|tea|:tea: timer|:tea:|timer|Té){1} (all|stop|info|mine|help){1}/i, (msg) ->
    cmd     = msg.match[2] or null
    cmdArgs = msg.match[1] or null

    processCommands msg, cmd, cmdArgs

  robot.respond /start (tea|timer|Té|:tea:) (.*)/i, (msg) ->
    startTimer  msg,  msg.match[2]

  robot.respond /(tea|timer|Té|:tea:) start (.*)/i, (msg) ->
    startTimer  msg, msg.match[2]


  robot.respond /open the (.*) doors/i, (res) ->
    doorType = res.match[1]
    if doorType is "pod bay"
      res.reply "I'm afraid I can't let you do that."
    else
      res.reply "Opening #{doorType} doors"
