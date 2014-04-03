passport = require 'passport'

module.exports.setupRoutes = (app) ->
  passport.serializeUser((user, done) ->
    console.log 'serializeUser'
    done(null, user._id))

  console.log 'TODOX'
