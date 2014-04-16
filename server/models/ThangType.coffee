mongoose = require 'mongoose'
plugins = require './plugins'

ThangTypeSchema = new mongoose.Schema({
  body: String,
}, {strict: false})

ThangTypeSchema.plugin(plugins.NamedPlugin)
# TODO

module.exports = mongoose.model('thang.type', ThangTypeSchema)
