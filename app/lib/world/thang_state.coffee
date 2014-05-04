{clone, typedArraySupport} = require './world_utils'

module.exports = class ThangState
  @className = 'ThangState'
  @trackedPropertyTypes: [
    'boolean'
    'number'
    'string'
    'array' # will turn everything into strings
    'object' # grrr
    'Vector'
    'Thang' # serialize as ids, like strings
  ]

  hasRestored: false
  constructor: (thang) -> console.log 'TD: constructor'

  getStateForProp: (prop) -> console.log 'TD: getStateForProp'

  restore: -> console.log 'TD: restore'

  serialize: (frameIndex, trackedPropertyIndices, trackedPropertyTypes, trackedPropertyValues, specialValuesToKeys, specialKeysToValues) ->
    console.log 'TD: serialize'

  @deserialize: (world, frameIndex, thang, trackedPropertyKeys, trackedPropertyTypes, trackedPropertyValues, specialKeysToValues) ->
    console.log 'TD: deserialize'

unless typedArraySupport
  console.log 'TD: typedArraySupport'
