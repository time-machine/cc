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
