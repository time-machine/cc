mongoose = require 'mongoose'

module.exports = class Handler
  # subclasses should overried these properties
  modelClass: null
  editableProperties: []
  postEditableProperties: []
  jsonSchema: {}
  waterfallFunctions: []

  # subclasses should overried these methods
  hasAccess: (req) -> true

  # sending functions
  sendNotFoundError: (res) -> @sendError(res, 404, 'Resource not found.')
  sendMethodNotAllowed: (res) -> console.log 'TD: sendMethodNotAllowed'

  sendError: (res, code, message) ->
    console.warn 'Sending an error code', code, message
    res.status(code)
    res.send(message)
    res.end()

  # generic handlers
  get: (req, res) -> console.log 'TD: Handler get'

  getById: (req, res, id) -> console.log 'TD: getById'

  getByRelationship: (req, res, args...) -> console.log 'TD: getByRelationship'

  search: (req, res) -> console.log 'TD: search'

  versions: (req, res, id) -> console.log 'TD: versions'

  files: (req, res, id) -> console.log 'TD: files'

  getLatestVersion: (req, res, original, version) ->
    # can get latest overall version, latest of a major version, or a specific version
    query = { 'original': mongoose.Types.ObjectId(original) }
    if version?
      console.log 'TD: getLatestVersion version', version
    sort = { 'version.major': -1, 'version.minor': -1 } # -1 means sort in descending order
    @modelClass.findOne(query).sort(sort).exec (err, doc) =>
      return @sendNotFoundError(res) unless doc?
      console.log 'TD: getLatestVersion', doc

  patch: -> console.log 'TD: Handler patch'

  put: (req, res, id) -> console.log 'TD: Handler put', id

  post: (req, res) -> console.log 'TD: Handler post'
