authentication = require('passport')
LocalStrategy = require('passport-local').Strategy
User = require('../users/User')
UserHandler = require('../users/user_handler')
LevelSession = require '../levels/sessions/LevelSession'
config = require '../../server_config'
errors = require '../commons/errors'
mail = require '../commons/mail'
languages = require '../routes/languages'

module.exports.setup = (app) ->
  authentication.serializeUser((user, done) -> done(null, user._id))
  authentication.deserializeUser((id, done) ->
    User.findById(id, (err, user) -> done(err, user)))

  authentication.use(new LocalStrategy(
    (username, password, done) ->
      User.findOne({emailLower:username.toLowerCase()}).exec((err, user) ->
        console.log 'TD: User.findOne'
      )
  ))
  app.post '/auth/spy', (req, res, next) ->
    console.log 'TD: /auth/spy'

  app.post('/auth/login', (req, res, next) ->
    console.log 'TD: /auth/login'
  )

  app.get('/auth/whoami', (req, res) ->
    if req.user
      sendSelf(req, res)
    else
      console.log 'TD: /auth/whoami'
  )

  sendSelf = (req, res) ->
    res.setHeader('Content-Type', 'text/json')
    res.send(UserHandler.formatEntity(req, req.user))
    res.end()

  app.post('/auth/logout', (req, res) ->
    console.log 'TD: /auth/logout'
  )

  app.post('/auth/reset', (req, res) ->
    console.log 'TD: /auth/reset'
  )

  app.get '/auth/unsubscribe', (req, res) ->
    console.log 'TD: /auth/unsubscribe'

module.exports.loginUser = loginUser = (req, res, user, send=true, next=null) ->
  console.log 'TD: loginUser'

module.exports.makeNewUser = makeNewUser = (req) ->
  console.log 'TD: makeNewUser'

createMailOptions = (receiver, password) ->
  # TODO: use email templates here
  options =
    from: config.mail.username
    to: receiver
    replyTo: config.mail.username
    subject: "[CodeCombat] Password Reset"
    text: "You can log into your account with: #{password}"

