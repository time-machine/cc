mongoose = require 'mongoose'
{handlers} = require '../commons/mapping'

PatchSchema = new mongoose.Schema({}, {strict: false})

PatchSchema.pre 'save', (next) ->
  console.log 'PatchSchema pre save'

module.exports = mongoose.model('patch', PatchSchema)
