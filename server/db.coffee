config = require '../server_config'
winston = require 'winston'
mongoose = require 'mongoose'
Grid = require 'gridfs-stream'

testing = '--unittest' in process.argv

module.exports.connectDatabase = ->
  dbName = config.mongo.db
  dbName += '_unittest' if testing
  address = config.mongo.host + ':' + config.mongo.port
  if config.mongo.username and config.mongo.passport
    console.log 'TD: connectDatabase'
  address = "mongodb://#{address}/#{dbName}"
  console.log 'got address:', address
  mongoose.connect address
  mongoose.connection.once 'open', ->
    Grid.gfs = Grid(mongoose.connection.db, mongoose.mongo)

module.exports.setupRoutes = (app) ->
  app.all '/db/*', (req, res) ->
    res.setHeader('Content-Type', 'application/json')
    module = req.path[4..]

    parts = module.split('/')
    module = parts[0]
    return getSchema(req, res, module) if parts[1] is 'schema'

    try
      name = "./handlers/#{module.replace '.', '_'}"
      module = require(name)
      return module.getLatestVersion(req, res, parts[1], parts[3]) if parts[2] is 'version'
      console.log 'TD: setupRoutes', module
    catch error
      winston.error("Error trying db method #{req.route.method} route #{parts} from #{name}: #{error}")
      winston.error(error)
      res.status(404)
      res.write("Route #{req.path} not found.")
      res.end()

getSchema = (req, res, moduleName) ->
  try
    name = "./schemas/#{moduleName.replace '.', '_'}"
    schema = require name
    res.send(schema)
    res.end()
  catch error
    winston.error "Error trying to grab schema from #{name}: #{error}"
    res.status(404)
    res.write "Schema #{moduleName} not found."
    res.end()
