User = require '../models/User'
Handler = require './Handler'
languages = require '../languages'

UserHandler = class UserHandler extends Handler
  modelClass: User

  getById: (req, res, id) ->
    console.log 'getById'

  post: (req, res) ->
    console.log('post')

  hasAccessToDocument: (req, doc) ->
    console.log 'hasAccessToDocument'

  getByRelationship: (req, res, args...) ->
    console.log 'getByRelationship'

  # TODOX: check is method trigger

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
  user.save((err) ->
    if err
      res.status(500)
      return res.end()

    console.log 'logIn'
    req.logIn(user, (err) ->
      console.log err

      if err
        res.status(500)
        return res.end()

      if send
        console.log 'TODO: loginUser'
      next() if next
    )
  )
