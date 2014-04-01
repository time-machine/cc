User = require '../models/User'
Handler = require './Handler'
languages = require '../languages'

UserHandler = class UserHandler extends Handler

module.exports = new UserHandler()

module.exports.setupMiddleware = (app) ->
  app.use (req, res, next) ->
    if req.user
      next()
    else
      user = new User({ anonymous: true })
      user.set 'testGroupNumber', Math.floor(Math.random() * 256) # also in app/lib/auth
      user.set 'preferredLanguage', languages.languageCodeFromAcceptedLanguages req.acceptedLanguages
      loginUser(req, res, user, false, next)

loginUser = (req, res, user, send=true, next=null) ->
  console.log 'TODOX', user

