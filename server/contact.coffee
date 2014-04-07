winston = require 'winston'

module.exports.setupRoutes = (app) ->
  app.post '/contact', (req, res) ->
    winston.info "TD: Sending mail from #{req.body.email} saying #{req.body.message}"
