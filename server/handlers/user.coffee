User = require '../models/User'
Handler = require './Handler'

UserHandler = class UserHandler extends Handler

module.exports = new UserHandler()

module.exports.setupMiddleware = (app) ->
  app.use (req, res, next) ->
    if req.user
      next()
    else
      user = new User({ anonymous: true })
      user.set 'testGroupNumber', Math.floor(Math.random() * 256) # also in app/lib/auth
      console.log 'TODO[server/handlers/user.coffee]', user

