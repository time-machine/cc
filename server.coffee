# Put lodash and underscore.string into the global namespace
GLOBAL._ = require('lodash')
_.str = require('underscore.string')
_.mixin(_.str.exports())

express = require('express')
path = require('path')
winston = require('winston')
passport = require('passport')
useragent = require 'express-useragent'

http = require('http')

config = require('./server_config')

# Express server setup
app = express()

oldBrowser = (req, res, next) ->
  return next() if req.query['try-old-browser-anyway'] or not isOldBrowser(req)
  res.sendfile(path.join(__dirname, 'public', 'index_old_browser.html'))

# determines order of middleware and request handling
app.configure(->
  app.use (req, res, next) ->
    req.setTimeout 15000, ->
      console.log 'timed out!'
      req.abort()
      self.emit('pass', message)
    next()

  app.use(express.logger('dev'))
  app.use(express.static(path.join(__dirname, 'public')))
  app.use(useragent.express())
  app.use '/play/', oldBrowser # When they go directly to play a level, they won't see our browser warning, so give it to 'em.
  app.set('port', config.port)
  app.set('views', __dirname + '/app/views')
  app.set('view engine', 'jade')
  app.set('view options', { layout: false })
  app.use(express.favicon())
  app.use(express.cookieParser(config.cookie_secret))
  app.use(express.bodyParser())
  app.use(express.methodOverride())
  app.use(express.cookieSession({ secret: 'defenestrate' }))
  # app.use(passport.initialize())
  # app.use(passport.session())
  if (config.slow_down)
    app.use((req, res, next) -> setTimeout((-> next()), 1000))

  app.use(app.router)
)

app.configure('development', -> app.use(express.errorHandler()))

# Anything that isn't handled at this point get index.html
app.get('*', (req, res) ->
  res.sendfile(path.join(__dirname, 'public', 'index.html'))
)

module.exports.startServer = ->
  http.createServer(app).listen(app.get('port'))
  winston.info("Express SSL server listening on port " + app.get('port'))
  return app

isOldBrowser = (req) ->
  # https://github.com/biggora/express-useragent/blob/master/lib/express-useragent.js
  return false unless ua = req.useragent
  return true if ua.isiPad or ua.isiPod or ua.isiPhone or ua.isOpera
  return false unless ua and ua.Browser in ["Chrome", "Safari", "Firefox", "IE"] and ua.Version
  b = ua.Browser
  v = parseInt ua.Version.split('.')[0], 10
  return true if b is 'Chrome' and v < 17
  return true if b is 'Safari' and v < 6
  return true if b is 'Firefox' and v < 21
  return true if b is 'IE' and v < 10
  false
