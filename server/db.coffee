config = require '../server_config'
winston = require 'winston'
mongoose = require 'mongoose'
Grid = require 'gridfs-stream'

testing = '--unittest' in process.argv

# FIXIT () not needed for no param?
module.exports.connectDatabase = () ->
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
      console.log 'TD: setupRoutes versions' if parts[2] is 'versions'
      console.log 'TD: setupRoutes files' if parts[2] is 'files'
      console.log 'TD: setupRoutes search' if req.route.method is 'get' and parts[1] is 'search'
      return module.getByRelationship(req, res, parts[1..]...) if parts.length > 2
      return module.getById(req, res, parts[1]) if req.route.method is 'get' and parts[1]?
      console.log 'TD: db setupRoutes', name, parts
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
