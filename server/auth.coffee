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
      console.log 'TD: username', username
  ))

  app.post('/auth/login', (req, res, next) ->
    console.log 'TD: /auth/login'
  )

  app.get('/auth/whoami', (req, res) ->
    res.setHeader('Content-Type', 'text/json')
    res.send(UserHandler.formatEntity(req, req.user))
    res.end()
  )

  app.post('/auth/logout', (req,res) ->
    console.log 'TD: /auth/logout'
  )

  app.post('/auth/reset', (req,res) ->
    console.log 'TD: /auth/reset'
  )
