passport = require 'passport'
User = require './models/User'

module.exports.setupRoutes = (app) ->
  passport.serializeUser((user, done) -> done(null, user._id))
  passport.deserializeUser((id, done) ->
    User.findById(id, (err, user) -> done(err, user))
  )

  app.get('/auth/whoami', (req, res) ->
    console.log 'getting auth whoami from server'
    res.setHeader('Content-Type', 'text/json') # what's setHeader
    res.send('server whoamii') # what's send
    res.end()
    console.log 'server whoami'
  )

  console.log 'TODOX server auth coffee'
