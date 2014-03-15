# Put lodash and underscore.string into the global namespace
GLOBAL._ = require('lodash')
_.str = require('underscore.string')
_.mixin(_.str.exports())

express = require('express')
path = require('path')
winston = require('winston')

http = require('http')

config = require('./server_config')

# Express server setup
app = express()

app.configure(->
  app.set('port', config.port)
)

# Anything that isn't handled at this point get index.html
app.get('*', (req, res) ->
  res.sendfile(path.join(__dirname, 'public', 'index.html'))
)

module.exports.startServer = ->
  http.createServer(app).listen(app.get('port'))
  winston.info("Express SSL server listening on port " + app.get('port'))
  return app
