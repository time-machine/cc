crypto = require 'crypto'
schema = require '../schemas/user'
User = require '../models/User'
Handler = require './Handler'
languages = require '../languages'

serverProperties = ['passwordHash', 'emailLower', 'nameLower', 'passwordReset']
privateProperties = ['permissions', 'email', 'firstName', 'lastName', 'gender', 'facebookID', 'music', 'volume']

UserHandler = class UserHandler extends Handler
  modelClass: User

  editableProperties: [
    'name', 'photoURL', 'password', 'anonymous', 'wizardColor1', 'volume',
    'firstName', 'lastName', 'gender', 'facebookID', 'emailSubscriptions',
    'testGroupNumber', 'music', 'hourOfCode', 'hourOfCodeComplete', 'preferredLanguage'
  ]

  jsonSchema: schema

  formatEntity: (req, document) ->
    return null unless document?
    obj = document.toObject()
    delete obj[prop] for prop in serverProperties
    includePrivates = req.user and (req.user.isAdmin() or req.user._id.equals(document._id))
    delete obj[prop] for prop in privateProperties unless includePrivates

    # emailHash is used by gravatar
    hash = crypto.createHash('md5')
    if document.get('email')
      hash.update(_.trim(document.get('email')).toLowerCase())
    else
      hash.update(@_id + '')
    obj.emailHash = hash.digest('hex')

    return obj

  waterfallFunctions: [
    # FB access token checking
    # Check the email is same as FB reports
    (req, user, callback) -> console.log 'TD: waterfallFunctions'
  ]

  getById: (req, res, id) -> console.log 'TD: getById'

  post: (req, res) -> console.log 'TD: post'

  hasAccessToDocument: (req, document) -> console.log 'TD: hasAccessToDocument'

  getByRelationship: (req, res, args...) -> console.log 'TD: getByRelationship'

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

    req.logIn(user, (err) ->
      if err
        res.status(500)
        return res.end()

      if send
        console.log 'TD: loginUser'
      next() if next
    )
  )
