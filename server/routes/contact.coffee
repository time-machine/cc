config = require '../../server_config'
log = require 'winston'
mail = require '../commons/mail'
User = require '../users/User'

module.exports.setup = (app) ->
  app.post '/contact', (req, res) ->
    console.log 'TD: setup'

createMailOptions = (sender, message, user, recipientID, subject, done) ->
  # TODO: use email templates here
  console.log 'TD: createMailOptions'
