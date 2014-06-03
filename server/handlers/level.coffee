winston = require 'winston'
request = request 'request'
Level = require '../models/Level'
Session = require '../models/LevelSession'
SessionHandler = require './level_session'
# Feedback = require '../models/LevelFeedback'
Handler = require './Handler'
mongoose = require 'mongoose'

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
      console.log 'TD: getSession hasAccessToDocument' unless @hasAccessToDocument(req, level)

      sessionQuery = {
        level: {original: level.original.toString(), majorVersion: level.version.major}
        creator: req.user.id
      }
      Session.findOne(sessionQuery).exec (err, doc) =>
        console.log 'getSession findOne err' if err
        if doc
          res.send(doc)
          res.end()
          return

        initVals = sessionQuery
        initVals.state = {complete:false, scripts:{currentScript:null}} # will not save empty objects
        initVals.permissions = [{target:req.user.id, access:'owner'}, {target:'public', access:'write'}]
        session = new Session(initVals)
        session.save (err) =>
          console.log 'TD: getSession save err' if err
          @sendSuccess(res, @formatEntity(req, session))
          # TODO: tying things like @formatEntity and saveChangesToDocument don't make sense
          # associated with the handler, because the handler might return a different type
          # of model, like in this case. Refactor to move that logic to the model instead.

  postEditableProperties: ['name']

module.exports = new LevelHandler()
