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
    console.log 'TODO'
  address = "mongodb://#{address}/#{dbName}"
  console.log 'got address:', address
  mongoose.connect address
  mongoose.connection.once 'open', ->
    Grid.gfs = Grid(mongoose.connection.db, mongoose.mongo)
