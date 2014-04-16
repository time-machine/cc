ThangType = require '../models/ThangType'
Handler = require './Handler'

ThangTypeHandler = class ThangTypeHandler extends Handler
  modelClass: ThangType

module.exports = new ThangTypeHandler()
