winston = require('winston')
request = require('request')
LevelSystem = require('../models/LevelSystem')
Handler = require('./Handler')

LevelSystemHandler = class LevelSystemHandler extends Handler
  modelClass: LevelSystem
  editableProperties: [
    'description',
    'code',
    'js',
    'language',
    'dependencies',
    'propertyDocumentation',
    'configSchema'
  ]
  postEditableProperties: ['name']

  getEditableProperties: (req, document) -> console.log 'TD: getEditableProperties'

  hasAccess: (req) -> console.log 'TD: hasAccess'

module.exports = new LevelSystemHandler()
