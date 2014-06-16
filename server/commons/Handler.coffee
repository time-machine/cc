async = require 'async'
mongoose = require('mongoose')
Grid = require 'gridfs-stream'
errors = require './errors'
log = require 'winston'
Patch = require '../patches/Patch'
User = require '../users/User'
sendwithus = require '../sendwithus'

PROJECT = {original:1, name:1, version:1, description: 1, slug:1, kind: 1}
FETCH_LIMIT = 200

module.exports = class Handler
  # subclasses should override these properties
  modelClass: null
  editableProperties: []
  postEditableProperties: []
  jsonSchema: {}
  waterfallFunctions: []

  # subclasses should override these methods
  hasAccess: (req) -> true
  hasAccessToDocument: (req, document, method=null) ->
    return true if req.user?.isAdmin()
    if @modelClass.schema.uses_coco_permissions
      return document.hasPermissionsForMethod?(req.user, method or req.method)
    return true

  formatEntity: (req, document) -> document?.toObject()
  getEditableProperties: (req, document) ->
    console.log 'TD: getEditableProperties'

  # sending functions
  sendUnauthorizedError: (res) -> errors.forbidden(res) #TODO: rename sendUnauthorizedError to sendForbiddenError
  sendNotFoundError: (res) -> errors.notFound(res)
  sendMethodNotAllowed: (res) -> errors.badMethod(res)
  sendBadInputError: (res, message) -> errors.badInput(res, message)
  sendDatabaseError: (res, err) ->
    console.log 'TD: sendDatabaseError'

  sendError: (res, code, message) ->
    errors.custom(res, code, message)

  sendSuccess: (res, message) ->
    res.send(message)
    res.end()

  # generic handlers
  get: (req, res) ->
    console.log 'TD: Handler get'

  getById: (req, res, id) ->
    # return @sendNotFoundError(res) # for testing
    return @sendUnauthorizedError(res) unless @hasAccess(req)

    @getDocumentForIdOrSlug id, (err, document) =>
      return @sendDatabaseError(res, err) if err
      return @sendNotFoundError(res) unless document?
      return @sendUnauthorizedError(res) unless @hasAccessToDocument(req, document)
      @sendSuccess(res, @formatEntity(req, document))

  getByRelationship: (req, res, args...) ->
    # this handler should be overwritten by subclasses
    if @modelClass.schema.is_patchable
      console.log 'TD: getByRelationship'
    return @sendNotFoundError(res)

  getNamesByIDs: (req, res) ->
    console.log 'TD: getNamesByIDs'

  getNamesByOriginals: (req, res) ->
    console.log 'TD: getNamesByOriginals'

  getPatchesFor: (req, res, id) ->
    console.log 'TD: getPatchesFor'

  setWatching: (req, res, id) ->
    console.log 'TD: setWatching'

  search: (req, res) -> console.log 'TD: search'

  versions: (req, res, id) -> console.log 'TD: versions'

  files: (req, res, id) -> console.log 'TD: files'

  getLatestVersion: (req, res, original, version) ->
    # can get latest overall version, latest of a major version, or a specific version
    query = { 'original': mongoose.Types.ObjectId(original) }
    if version?
      version = version.split('.')
      majorVersion = parseInt(version[0])
      minorVersion = parseInt(version[1])
      query['version.major'] = majorVersion unless _.isNaN(majorVersion)
      query['version.minor'] = minorVersion unless _.isNaN(minorVersion)
    sort = { 'version.major': -1, 'version.minor': -1 } # -1 means sort in descending order
    @modelClass.findOne(query).sort(sort).exec (err, doc) =>
      return @sendNotFoundError(res) unless doc?
      console.log 'TD: getLatestVersion' unless @hasAccessToDocument(req, doc)
      res.send(doc)
      res.end()

  patch: -> console.log 'TD: Handler patch'

  put: (req, res, id) -> console.log 'TD: Handler put', id

  post: (req, res) -> console.log 'TD: Handler post'

  getDocumentForIdOrSlug: (idOrSlug, done) ->
    idOrSlug = idOrSlug + ''
    try
      mongoose.Types.ObjectId.createFromHexString(idOrSlug) # throw error if not a valid ID (probably a slug)
      @modelClass.findById(idOrSlug).exec (err, document) ->
        done(err, document)
    catch e
      @modelClass.findOne {slug: idOrSlug}, (err, document) =>
        done(err, document)
