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

  getByRelationship: (req, res, args...) ->
    return @getSession(req, res, args[0]) if args[1] is 'session'
    console.log 'TD: getByRelationship', args

  getSession: (req, res, id) ->
    @getDocumentForIdOrSlug id, (err, level) =>
      console.log 'TD: getSession error' if err
      return @sendNotFoundError(res) unless level?
      console.log 'TD: getSession', id

  postEditableProperties: ['name']

module.exports = new LevelHandler()
