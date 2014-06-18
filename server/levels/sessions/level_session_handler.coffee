LevelSession = require('./LevelSession')
Handler = require('../../commons/Handler')
log = require 'winston'

TIMEOUT = 1000 * 30 # no activity for 30 seconds means it's not active

class LevelSessionHandler extends Handler
  modelClass: LevelSession
  editableProperties: ['multiplayer', 'players', 'code', 'codeLanguage', 'completed', 'state',
                       'levelName', 'creatorName', 'levelID', 'screenshot',
                       'chat', 'teamSpells', 'submitted', 'unsubscribed','playtime']
  jsonSchema: require '../../../app/schemas/models/level_session'

  getByRelationship: (req, res, args...) ->
    console.log 'TD: getByRelationship'

  formatEntity: (req, document) ->
    console.log 'TD: formatEntity'

  getActiveSessions: (req, res) ->
    console.log 'TD: getActiveSessions'

  hasAccessToDocument: (req, document, method=null) ->
    console.log 'TD: hasAccessToDocument'

module.exports = new LevelSessionHandler()
