mail = require '../commons/mail'
User = require '../users/User'
errors = require '../commons/errors'
#request = require 'request'
config = require '../../server_config'
LevelSession = require '../levels/sessions/LevelSession'
Level = require '../levels/Level'
log = require 'winston'
sendwithus = require '../sendwithus'

#badLog = (text) ->
#  console.log text
#  request.post 'http://requestb.in/1brdpaz1', { form: {log: text} }

module.exports.setup = (app) ->
  app.all config.mail.mailchimpWebhook, handleMailchimpWebHook
  app.get '/mail/cron/ladder-update', handleLadderUpdate

getAllLadderScores = (next) ->
  console.log 'TD: getAllLadderScores'

DEBUGGING = false
LADDER_PREGAME_INTERVAL = 2 * 3600 * 1000  # Send emails two hours before players last submitted.
getTimeFromDaysAgo = (now, daysAgo) ->
  t = now - 86400 * 1000 * daysAgo - LADDER_PREGAME_INTERVAL

isRequestFromDesignatedCronHandler = (req, res) ->
  console.log 'TD: isRequestFromDesignatedCronHandler'

handleLadderUpdate = (req, res) ->
  console.log 'handleLadderUpdate'

sendLadderUpdateEmail = (session, now, daysAgo) ->
  console.log 'TD: sendLadderUpdateEmail'

getScoreHistoryGraphURL = (session, daysAgo) ->
  console.log 'TD: getScoreHistoryGraphURL'

handleMailchimpWebHook = (req, res) ->
  config.log 'TD: handleMailchimpWebHook'

module.exports.handleProfileUpdate = handleProfileUpdate = (user, post) ->
  console.log 'TD: handleProfileUpdate'

module.exports.handleUnsubscribe = handleUnsubscribe = (user) ->
  console.log 'TD: handleUnsubscribe'
