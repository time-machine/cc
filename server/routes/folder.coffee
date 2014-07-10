mongoose = require 'mongoose'
errors = require '../commons/errors'

module.exports.setup = (app) ->
  app.all '/folder*', (req, res) ->
    return folderGet(req, res) if req.route.method is 'get'
    return errors.badMethod(res, ['GET'])

folderGet = (req, res) ->
  console.log 'TD: folderGet'
