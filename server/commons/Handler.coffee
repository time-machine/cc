async = require 'async'
mongoose = require 'mongoose'
Grid = require 'gridfs-stream'
errors = require './errors'
log = require 'winston'
Patch = require '../patches/Patch'
User = require '../users/User'
sendwithus = require '../sendwithus'

PROJECT = {original: 1, name: 1, version: 1, description: 1, slug: 1, kind: 1}
FETCH_LIMIT = 200

module.exports = class Handler
  # subclasses should override these properties
  modelClass: null
  editableProperties: []
  postEditableProperties: []
  jsonSchema: {}
  waterfallFunctions: []
  allowedMethods: ['GET', 'POST', 'PUT', 'PATCH']

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

  versions: (req, res, id) ->
    console.log 'TD: versions'

  files: (req, res, id) ->
    console.log 'TD: files'

  getLatestVersion: (req, res, original, version) ->
    # can get latest overall version, latest of a major version, or a specific version
    query = { 'original': mongoose.Types.ObjectId(original) }
    if version?
      version = version.split('.')
      majorVersion = parseInt(version[0])
      minorVersion = parseInt(version[1])
      query['version.major'] = majorVersion unless _.isNaN(majorVersion)
      query['version.minor'] = minorVersion unless _.isNaN(minorVersion)
    sort = { 'version.major': -1, 'version.minor': -1 }
    args = [query]
    args.push PROJECT if req.query.project
    @modelClass.findOne(args...).sort(sort).exec (err, doc) =>
      return @sendNotFoundError(res) unless doc?
      return @sendUnauthorizedError(res) unless @hasAccessToDocument(req, doc)
      res.send(doc)
      res.end()

  patch: ->
    @put(arguments...)

  put: (req, res, id) ->
    console.log 'TD: Handler put'

  post: (req, res) ->
    console.log 'TD: Handler post'

  onPostSuccess: (req, doc) ->

  ###
  TODO: think about pulling some common stuff out of postFirstVersion/postNewVersion
  into a postVersion if we can figure out the breakpoints?
  ..... actually, probably better would be to do the returns with throws instead
  and have a handler which turns them into status codes and messages
  ###
  postFirstVersion: (req, res) ->
    console.log 'TD: postFirstVersion'

  postNewVersion: (req, res) ->
    console.log 'TD: postNewVersion'

  notifyWatchersOfChange: (editor, changedDocument, editPath) ->
    console.log 'TD: notifyWatchersOfChange'

  notifyWatcherOfChange: (editor, watcher, changedDocument, editPath) ->
    console.log 'TD: notifyWatcherOfChange'

  makeNewInstance: (req) ->
    console.log 'TD: makeNewInstance'

  validateDocumentInput: (input) ->
    console.log 'TD: validateDocumentInput'

  @isID: (id) -> _.isString(id) and id.length is 24 and id.match(/[a-f0-9]/gi)?.length is 24

  getDocumentForIdOrSlug: (idOrSlug, done) ->
    idOrSlug = idOrSlug+''
    if Handler.isID(idOrSlug)
      @modelClass.findById(idOrSlug).exec (err, document) ->
        done(err, document)
    else
      @modelClass.findOne {slug: idOrSlug}, (err, document) ->
        done(err, document)

  doWaterfallChecks: (req, document, done) ->
    console.log 'TD: doWaterfallChecks'

  saveChangesToDocument: (req, document, done) ->
    console.log 'TD: saveChangesToDocument'

  getPropertiesFromMultipleDocuments: (res, model, properties, ids) ->
    console.log 'TD: getPropertiesFromMultipleDocuments'

  delete: (req, res) -> @sendMethodNotAllowed res, @allowedMethods, 'DELETE not allowed.'

  head: (req, res) -> @sendMethodNotAllowed res, @allowedMethods, 'HEAD not allowed.'
