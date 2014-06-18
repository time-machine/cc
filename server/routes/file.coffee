Grid = require 'gridfs-stream'
fs = require 'fs'
request = require 'request'
mongoose = require('mongoose')
errors = require '../commons/errors'

module.exports.setup = (app) ->
  app.all '/file*', (req, res) ->
    return fileGet(req, res) if req.route.method is 'get'
    return filePost(req, res) if req.route.method is 'post'
    return errors.badMethod(res, ['GET', 'POST'])


fileGet = (req, res) ->
  path = req.path[6..]
  path = decodeURI path
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
    Grid.gfs.collection('media').findOne query, (err, filedata) =>
      return errors.notFound(res) if not filedata
      readstream = Grid.gfs.createReadStream({_id: filedata._id, root:'media'})
      if req.headers['if-modified-since'] is filedata.uploadDate
        res.status(304)
        return res.end()

      res.setHeader('Content-Type', filedata.contentType)
      res.setHeader('Last-Modified', filedata.uploadDate)
      res.setHeader('Cache-Control', 'public')
      readstream.pipe(res)
      handleStreamEnd(res, res)

postFileSchema =
  type: 'object'
  properties:
    # source
    url: { type: 'string', description: 'The url to download the file from.' }
    postName: { type: 'string', description: 'The input field this file was sent on.' }
    b64png: { type: 'string', description: 'Raw png data to upload.' }

    # options
    force: { type: 'string', 'default': '', description: 'Whether to overwrite existing files (as opposed to throwing an error).' }

    # metadata
    filename: { type: 'string', description: 'What the file will be named in the system.' }
    mimetype: { type: 'string' }
    name: { type: 'string', description: 'Human readable and searchable string.' }
    description: { type: 'string' }
    path: { type: 'string', description: 'What "folder" this file goes into.' }

  required: ['filename', 'mimetype', 'path']

filePost = (req, res) ->
  console.log 'TD: filePost'

saveURL = (req, res) ->
  console.log 'TD: saveURL'

saveFile = (req, res) ->
  console.log 'saveFile'

savePNG = (req, res) ->
  console.log 'savePNG'

userCanEditFile = (user=null, file=null) ->
  console.log 'TD: userCanEditFile'

checkExistence = (options, req, res, force, done) ->
  console.log 'TD: checkExistence'

handleStreamEnd = (res, stream) ->
  stream.on 'close', (f) ->
    res.send(f)
    res.end()

  stream.on 'error', ->
    return errors.serverError(res)

CHUNK_SIZE = 1024*256

createPostOptions = (req) ->
  console.log 'TD: createPostOptions'
