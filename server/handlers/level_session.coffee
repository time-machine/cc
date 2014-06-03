LevelSession = require '../models/LevelSession'
Handler = require './Handler'

class LevelSessionHandler extends Handler
  modelClass: LevelSession
  editableProperties: ['multiplayer', 'players', 'code', 'completed', 'state',
                       'levelName', 'creatorName', 'levelID', 'screenshot',
                       'chat']

  getByRelationship: (req, res, args...) -> console.log 'TD: getByRelationship'

module.exports = new LevelSessionHandler()
