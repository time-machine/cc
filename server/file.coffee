Grid = require 'gridfs-stream'
mongoose = require 'mongoose'

module.exports.setupRoutes = (app) ->
  app.all '/file*', (req, res) ->
    return fileGet(req, res) if req.route.method is 'get'
    console.log 'TD: file setupRoutes', req.route

fileGet = (req, res) ->
  path = req.path[6..]
  isFolder = false
  try
    objectId = mongoose.Types.ObjectId(path)
    query = objectId
  catch e
    path = path.split('/')
    filename = path[path.length-1]
    path = path[...path.length-1].join('/')
    query =
      'metadata.path': path
    if filename then query.filename = filename else isFolder = true

  if isFolder
    console.log 'TD: fileGet isFolder'
  else
    Grid.gfs.collection('media').findOne query, (err, filedata) ->
      return returnNotFound(req, res) if not filedata
      console.log 'TD: fileGet media'

returnNotFound = (req, res, message) ->
  res.status(404)
  message = "Route #{req.path} not found." unless message
  res.write(message)
  res.end()
