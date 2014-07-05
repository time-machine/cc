mongoose = require 'mongoose'
EarnedAchievement = require '../achievements/EarnedAchievement'
LocalMongo = require '../../app/lib/LocalMongo'
util = require '../../app/lib/utils'
log = require 'winston'

achievements = {}

module.exports = AchievablePlugin = (schema, options) ->
  User = require '../users/User'  # Avoid mutual inclusion cycles
  Achievement = require '../achievements/Achievement'

  checkForAchievement = (doc) ->
    console.log 'TD: checkForAchievement'

  before = {}

  schema.post 'init', (doc) ->
    console.log 'TD: post init'

  schema.post 'save', (doc) ->
    console.log 'TD: post save'

module.exports.loadAchievements = ->
  console.log 'TD: loadAchievements'

AchievablePlugin.loadAchievements()
