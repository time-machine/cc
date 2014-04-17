ThangType = require '../models/ThangType'
Handler = require './Handler'

ThangTypeHandler = class ThangTypeHandler extends Handler
  modelClass: ThangType
  editableProperties: [
    'name',
    'raw',
    'actions',
    'soundTriggers',
    'rotationType',
    'matchWorldDimensions',
    'shadow',
    'layerPriority',
    'staticImage',
    'scale',
    'positions',
    'snap',
    'components'
  ]

  hasAccess: (req) -> console.log 'TD: hasAccess'

module.exports = new ThangTypeHandler()
