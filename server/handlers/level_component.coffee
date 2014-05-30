winston = require('winston')
request = require('request')
LevelComponent = require('../models/LevelComponent')
Handler = require('./Handler')

LevelComponentHandler = class LevelComponentHandler extends Handler
  modelClass: LevelComponent
  editableProperties: [
    'system'
    'description'
    'code'
    'js'
    'language'
    'dependencies'
    'propertyDocumentation'
    'configSchema'
  ]
  postEditableProperties: ['name']

  getEditableProperties: (req, document) -> console.log 'TD: getEditableProperties'

  hasAccess: (req) -> console.log 'TD: hasAccess'

module.exports = new LevelComponentHandler()
