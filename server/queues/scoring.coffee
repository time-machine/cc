config = require '../../server_config'
log = require 'winston'
mongoose = require 'mongoose'
async = require 'async'
errors = require '../commons/errors'
aws = require 'aws-sdk'
db = require './../routes/db'
queues = require '../commons/queue'
LevelSession = require '../levels/sessions/LevelSession'
Level = require '../levels/Level'
User = require '../users/User'
TaskLog = require './task/ScoringTask'
bayes = new (require 'bayesian-battle')()

scoringTaskQueue = undefined
scoringTaskTimeoutInSeconds = 240

module.exports.setup = (app) -> connectToScoringQueue()

connectToScoringQueue = ->
  console.log 'TD: connectToScoringQueue'

module.exports.messagesInQueueCount = (req, res) ->
  console.log 'TD: messagesInQueueCount'

module.exports.addPairwiseTaskToQueueFromRequest = (req, res) ->
  console.log 'TD: addPairwiseTaskToQueueFromRequest'

addPairwiseTaskToQueue = (taskPair, cb) ->
  console.log 'TD: addPairwiseTaskToQueue'

# We should rip these out, probably
module.exports.resimulateAllSessions = (req, res) ->
  console.log 'TD: resimulateAllSessions'

resimulateSession = (originalLevelID, levelMajorVersion, session, cb) =>
  console.log 'TD: resimulateSession'

selectRandomSkipIndex = (numberOfSessions) ->
  console.log 'TD: selectRandomSkipIndex'

module.exports.getTwoGames = (req, res) ->
  console.log 'TD: getTwoGames'

module.exports.recordTwoGames = (req, res) ->
  console.log 'TD: recordTwoGames'

module.exports.createNewTask = (req, res) ->
  console.log 'TD: createNewTask'

validatePermissions = (req, sessionID, callback) ->
  console.log 'TD: validatePermissions'

fetchAndVerifyLevelType = (levelID, cb) ->
  console.log 'TD: fetchAndVerifyLevelType'

fetchSessionObjectToSubmit = (sessionID, callback) ->
  console.log 'TD: fetchSessionObjectToSubmit'

updateSessionToSubmit = (transpiledCode, sessionToUpdate, callback) ->
  console.log 'TD: updateSessionToSubmit'

fetchInitialSessionsToRankAgainst = (levelMajorVersion, levelID, submittedSession, callback) ->
  console.log 'TD: fetchInitialSessionsToRankAgainst'

generateAndSendTaskPairsToTheQueue = (sessionToRankAgainst, submittedSession, callback) ->
  console.log 'TD: generateAndSendTaskPairsToTheQueue'

module.exports.dispatchTaskToConsumer = (req, res) ->
  console.log 'TD: dispatchTaskToConsumer'

checkSimulationPermissions = (req, cb) ->
  console.log 'TD: checkSimulationPermissions'

receiveMessageFromSimulationQueue = (cb) ->
  console.log 'TD: receiveMessageFromSimulationQueue'

changeMessageVisibilityTimeout = (message, cb) ->
  console.log 'TD: changeMessageVisibilityTimeout'

parseTaskQueueMessage = (message, cb) ->
  console.log 'TD: parseTaskQueueMessage'

constructTaskObject = (taskMessageBody, message, callback) ->
  console.log 'TD: constructTaskObject'
