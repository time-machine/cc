log = require 'winston'
errors = require '../commons/errors'
handlers = require('../commons/mapping').handlers

mongoose = require 'mongoose'

module.exports.setup = (app) ->
  app.post '/admin/*', (req, res) ->
    console.log 'TD: post admin'
