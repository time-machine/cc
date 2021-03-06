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

constructTaskLogObject = (calculatorUserID, taskObject, message, callback) ->
  console.log 'constructTaskLogObject'

processTaskObject = (taskObject, taskLogObject, message, cb) ->
  console.log 'TD: processTaskObject'

getSessionInformation = (sessionIDString, callback) ->
  console.log 'getSessionInformation'

module.exports.processTaskResult = (req, res) ->
  console.log 'TD: processTaskResult'

verifyClientResponse = (responseObject, callback) ->
  console.log 'TD: verifyClientResponse'

fetchTaskLog = (responseObject, callback) ->
  console.log 'TD: fetchTaskLog'

checkTaskLog = (taskLog, callback) ->
  console.log 'TD: checkTaskLog'

deleteQueueMessage = (callback) ->
  console.log 'TD: deleteQueueMessage'

fetchLevelSession = (callback) ->
  console.log 'TD: fetchLevelSession'

checkSubmissionDate = (callback) ->
  console.log 'TD: checkSubmissionDate'

logTaskComputation = (callback) ->
  console.log 'TD: logTaskComputation'

updateSessions = (callback) ->
  console.log 'TD: updateSessions'

saveNewScoresToDatabase = (newScoreArray, callback) ->
  console.log 'TD: saveNewScoresToDatabase'

updateScoreInSession = (scoreObject, callback) ->
  console.log 'TD: updateScoreInSession'

indexNewScoreArray = (newScoreArray, callback) ->
  console.log 'TD: indexNewScoreArray'

addMatchToSessions = (newScoreObject, callback) ->
  console.log 'TD: addMatchToSessions'

updateMatchesInSession = (matchObject, sessionID, callback) ->
  console.log 'TD: updateMatchesInSession'

updateUserSimulationCounts = (reqUserID, callback) ->
  console.log 'TD: updateUserSimulationCounts'

incrementUserSimulationCount = (userID, type, callback) =>
  console.log 'TD: incrementUserSimulationCount'

determineIfSessionShouldContinueAndUpdateLog = (cb) ->
  console.log 'TD: determineIfSessionShouldContinueAndUpdateLog'

findNearestBetterSessionID = (cb) ->
  console.log 'TD: findNearestBetterSessionID'

retrieveAllOpponentSessionIDs = (sessionID, cb) ->
  console.log 'TD: retrieveAllOpponentSessionIDs'

calculateOpposingTeam = (sessionTeam) ->
  console.log 'TD: calculateOpposingTeam'

addNewSessionsToQueue = (sessionID, callback) ->
  console.log 'TD: addNewSessionsToQueue'

messageIsInvalid = (message) -> (not message?) or message.isEmpty()

sendEachTaskPairToTheQueue = (taskPairs, callback) -> console.log 'TD: sendEachTaskPairToTheQueue'

generateTaskPairs = (submittedSessions, sessionToScore) ->
  console.log 'TD: generateTaskPairs'

sendTaskPairToQueue = (taskPair, callback) ->
  console.log 'TD: sendTaskPairToQueue'

getUserIDFromRequest = (req) -> if req.user? then return req.user._id else return null

isUserAnonymous = (req) -> if req.user? then return req.user.get('anonymous') else return true

isUserAdmin = (req) -> return Boolean(req.user?.isAdmin())

sendResponseObject = (req, res, object) ->
  console.log 'TD: sendResponseObject'

hasTaskTimedOut = (taskSentTimestamp) -> taskSentTimestamp + scoringTaskTimeoutInSeconds * 1000 < Date.now()

handleTimedOutTask = (req, res, taskBody) -> errors.clientTimeout res, 'The results weren\'t provided within the timeout'

putRankingFromMetricsIntoScoreObject = (taskObject, scoreObject) ->
  console.log 'TD: putRankingFromMetricsIntoScoreObject'

retrieveOldSessionData = (sessionID, callback) ->
  console.log 'TD: retrieveOldSessionData'

markSessionAsDoneRanking = (sessionID, cb) ->
  console.log 'TD: markSessionAsDoneRanking'
