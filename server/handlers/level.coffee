Level = require '../models/Level'
Handler = require './Handler'

LevelHandler = class LevelHandler extends Handler
  modelClass: Level
  editableProperties: [
    'description'
    'documentation'
    'background'
    'nextLevel'
    'scripts'
    'thangs'
    'systems'
    'victory'
    'name'
    'i18n'
    'icon'
  ]

  getByRelationship: (req, res, args...) -> console.log 'TD: getByRelationship'

  postEditableProperties: ['name']

module.exports = new LevelHandler()
