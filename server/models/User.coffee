mongoose = require 'mongoose'

UserSchema = new mongoose.Schema({
  dateCreated:
    type: Date
    'default': Date.now
}, { strict: false })

module.exports = User = mongoose.model('User', UserSchema)
