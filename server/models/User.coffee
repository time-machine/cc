mongoose = require 'mongoose'
jsonschema = require '../schemas/user'

UserSchema = new mongoose.Schema({
  dateCreated:
    type: Date
    'default': Date.now
}, { strict: false })

UserSchema.pre('init', (next) ->
  console.log 'TODO: pre init'
  next()
)

UserSchema.post('init', ->
  console.log 'TODO: post init'
)

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
