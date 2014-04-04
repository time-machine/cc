passport = require 'passport'
LocalStrategy = require('passport-local').Strategy
User = require './models/User'
UserHandler = require './handlers/user'

module.exports.setupRoutes = (app) ->
  passport.serializeUser((user, done) -> done(null, user._id))
  passport.deserializeUser((id, done) ->
    User.findById(id, (err, user) -> done(err, user))
  )

  passport.use(new LocalStrategy(
    (username, password, done) ->
      console.log 'TODO: username', username
  ))

  # this will get invoke when client calls $.get('/auth/whoami')
  app.get('/auth/whoami', (req, res) ->
    res.setHeader('Content-Type', 'text/json')
    res.send(UserHandler.formatEntity(req, req.user))
    res.end()
  )
