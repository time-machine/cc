mongoose = require 'mongoose'
jsonschema = require '../schemas/user'

UserSchema = new mongoose.Schema({
  dateCreated:
    type: Date
    'default': Date.now
}, { strict: false })

UserSchema.pre('init', (next) ->
  return next() unless jsonschema.properties?
  for prop, sch of jsonschema.properties
    @set(prop, sch.default) if sch.default?
  next()
)

UserSchema.post('init', ->
  @set('anonymous', false) if @get('email')
  @currentSubscriptions = JSON.stringify(@get('emailSubscriptions'))
)

UserSchema.methods.isAdmin = ->
  p = @get('permissions')
  return p and 'admin' in p

UserSchema.statics.updateMailChimp = (doc, callback) ->
  return callback?() if doc.updatedMailChimp
  return callback?() unless doc.get('email')
  console.log 'TODO: updateMailChimp'

UserSchema.pre('save', (next) ->
  @set('emailLower', @get('email')?.toLowerCase())
  @set('nameLower', @get('name')?.toLowerCase())
  pwd = @get('password')
  if @get('password')
    console.log 'TODO: pre save'
  @set('anonymous', false) if @get('email')
  next()
)

UserSchema.post 'save', (doc) ->
  UserSchema.statics.updateMailChimp(doc)

module.exports = User = mongoose.model('User', UserSchema)
