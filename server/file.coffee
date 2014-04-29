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
      readstream = Grid.gfs.createReadStream({_id: filedata._id, root: 'media'})
      if req.headers['if-modified-since'] is filedata.uploadDate
        console.log 'TD: fileGet if-modified-since'

      res.setHeader('Content-Type', filedata.contentType)
      res.setHeader('Last-Modified', filedata.uploadDate)
      res.setHeader('Cache-Control', 'public')
      readstream.pipe(res)
      handleStreamEnd(res, res)

handleStreamEnd = (res, stream) ->
  stream.on 'close', (f) ->
    res.send(f)
    res.end()

  stream.on 'error', ->
    return returnServerError(res)

returnNotFound = (req, res, message) ->
  res.status(404)
  message = "Route #{req.path} not found." unless message
  res.write(message)
  res.end()

returnServerError = (res) ->
  res.status(500)
  res.send('Server error.')
  res.end()
