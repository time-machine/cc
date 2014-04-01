mongoose = require 'mongoose'

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

UserSchema.pre('save', (next) ->
  console.log 'TODO: pre save'
  next()
)

UserSchema.post 'save', (doc) ->
  console.log 'TODO: post save'

module.exports = User = mongoose.model('User', UserSchema)
