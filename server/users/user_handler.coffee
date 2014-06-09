schema = require '../../app/schemas/models/user'
crypto = require 'crypto'
request = require 'request'
User = require './User'
Handler = require '../commons/Handler'
mongoose = require 'mongoose'
config = require '../../server_config'
errors = require '../commons/errors'
async = require 'async'
log = require 'winston'
LevelSession = require('../levels/sessions/LevelSession')
LevelSessionHandler = require '../levels/sessions/level_session_handler'
EarnedAchievement = require '../achievements/EarnedAchievement'

serverProperties = ['passwordHash', 'emailLower', 'nameLower', 'passwordReset']
privateProperties = [
  'permissions', 'email', 'firstName', 'lastName', 'gender', 'facebookID',
  'gplusID', 'music', 'volume', 'aceConfig', 'employerAt', 'signedEmployerAgreement'
]
candidateProperties = [
  'jobProfile', 'jobProfileApproved', 'jobProfileNotes'
]

UserHandler = class UserHandler extends Handler
  modelClass: User

  editableProperties: [
    'name', 'photoURL', 'password', 'anonymous', 'wizardColor1', 'volume',
    'firstName', 'lastName', 'gender', 'facebookID', 'gplusID', 'emails',
    'testGroupNumber', 'music', 'hourOfCode', 'hourOfCodeComplete', 'preferredLanguage',
    'wizard', 'aceConfig', 'autocastDelay', 'lastLevel', 'jobProfile'
  ]

  jsonSchema: schema

  constructor: ->
    console.log 'TD: constructor'

  getEditableProperties: (req, document) ->
    console.log 'TD: getEditableProperties'

  formatEntity: (req, document) ->
    return null unless document?
    obj = document.toObject()
    delete obj[prop] for prop in serverProperties
    includePrivates = req.user and (req.user.isAdmin() or req.user._id.equals(document._id))
    delete obj[prop] for prop in privateProperties unless includePrivates
    includeCandidate = includePrivates or (obj.jobProfileApproved and req.user and ('employer' in (req.user.get('permissions') ? [])) and @employerCanViewCandidate req.user, obj)
    delete obj[prop] for prop in candidateProperties unless includeCandidate
    return obj

  waterfallFunctions: [
    # FB access token checking
    # Check the email is the same as FB reports
    (req, user, callback) ->
      console.log 'TD: waterfallFunctions'
  ]

  getById: (req, res, id) ->
    console.log 'TD: getById'

  getNamesByIDs: (req, res) ->
    console.log 'TD: getNamesByIDs'

  nameToID: (req, res, name) ->
    console.log 'TD: nameToID'

  getSimulatorLeaderboard: (req, res) ->
    console.log 'TD: getSimulatorLeaderboard'

  getMySimulatorLeaderboardRank: (req, res) ->
    console.log 'TD: getMySimulatorLeaderboardRank'

  getSimulatorLeaderboardQueryParameters: (req) ->
    console.log 'TD: getSimulatorLeaderboardQueryParameters'

  validateSimulateLeaderboardRequestParameters: (req) ->
    console.log 'TD: validateSimulatorLeaderboardRequestParameters'

  post: (req, res) ->
    console.log 'TD: post'

  hasAccessToDocument: (req, document) ->
    console.log 'TD: user hasAccessToDocument'

  getByRelationship: (req, res, args...) ->
    console.log 'TD: getByRelationship'

  agreeToCLA: (req, res) ->
    console.log 'TD: agreeToCLA'

  avatar: (req, res, id) ->
    console.log 'TD: avatar'

  getLevelSessions: (req, res, userID) ->
    console.log 'TD: getLevelSessions'

  getEarnedAchievements: (req, res, userID) ->
    console.log 'TD: getEarnedAchievements'

  agreeToEmployerAgreement: (req, res) ->
    console.log 'TD: agreeToEmployerAgreement'

  getCandidates: (req, res) ->
    console.log 'TD: getCandidates'

  formatCandidate: (authorized, document) ->
    console.log 'TD: formatCandidate'

  employerCanViewCandidate: (employer, candidate) ->
    console.log 'TD: employerCanViewCandidate'

  buildGravatarURL: (user, size, fallback) ->
    console.log 'TD: buildGravatarURL'

  buildEmailHash: (user) ->
    # emailHash is used by gravatar
    hash = crypto.createHash('md5')
    if user.get('email')
      hash.update(_.trim(user.get('email')).toLowerCase())
    else
      hash.update(user.get('_id') + '')
    hash.digest('hex')

module.exports = new UserHandler()
