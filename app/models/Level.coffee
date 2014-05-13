CocoModel = require './CocoModel'

module.exports = class Level extends CocoModel
  @className: 'Level'
  urlRoot: '/db/level'

  serialize: (supermodel) -> console.log 'TD: serialize'

  dimensions: -> console.log 'TD: dimensions'

  getReferencedModels: (data, schema, path='/') ->
    models = super data, schema, path
    console.log 'TD: getReferencedModels'
