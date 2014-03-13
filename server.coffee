express = require('express')
winston = require('winston')

http = require('http')

config = require('./server_config')

# Express server setup
app = express()

app.configure(->
  app.set('port', config.port)
)

module.exports.startServer = ->
  http.createServer(app).listen(app.get('port'))
  winston.info("Express SSL server listening on port " + app.get('port'))
  return app
