mongoose = require 'mongoose'

ThangTypeSchema = new mongoose.Schema({
  body: String,
}, {strict: false})

module.exports = mongoose.model('thang.type', ThangTypeSchema)
