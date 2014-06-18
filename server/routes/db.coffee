log = require 'winston'
errors = require '../commons/errors'
handlers = require('../commons/mapping').handlers
mongoose = require 'mongoose'

module.exports.setup = (app) ->
  # This is hacky and should probably get moved somewhere else, I dunno
  app.get '/db/cla.submissions', (req, res) ->
    console.log 'TD: setup db submissions'

  app.all '/db/*', (req, res) ->
    console.log 'TD: db'

getSchema = (req, res, moduleName) ->
  console.log 'TD: getSchema'
