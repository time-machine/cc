mongoose = require('mongoose')
jsonschema = require('../../app/schemas/models/user')
crypto = require('crypto')
{salt, isProduction} = require('../../server_config')
mail = require '../commons/mail'
log = require 'winston'

sendwithus = require '../sendwithus'

UserSchema = new mongoose.Schema({
  dateCreated:
    type: Date
    'default': Date.now
}, {strict: false})

UserSchema.pre('init', (next) ->
  return next() unless jsonschema.properties?
  for prop, sch of jsonschema.properties
    continue if prop is 'emails' # defaults may change, so don't carry them over just yet
    @set(prop, sch.default) if sch.default?
  next()
)

UserSchema.post('init', ->
  @set('anonymous', false) if @get('email')
)

UserSchema.methods.isAdmin = ->
  p = @get('permissions')
  return p and 'admin' in p

UserSchema.methods.trackActivity = (activityName, increment) ->
  console.log 'TD: trackActivity'

UserSchema.statics.updateMailChimp = (doc, callback) ->
  return callback?() if doc.updatedMailChimp
  return callback?() unless doc.get('email')
  console.log 'TD: updateMailChimp'

UserSchema.pre('save', (next) ->
  @set('emailLower', @get('email')?.toLowerCase())
  @set('nameLower', @get('name')?.toLowerCase())
  pwd = @get('password')
  if @get('password')
    console.log 'TD: pre save'
  @set('anonymous', false) if @get('email')
  next()
)

UserSchema.post 'save', (doc) ->
  UserSchema.statics.updateMailChimp(doc)

module.exports = User = mongoose.model('User', UserSchema)
