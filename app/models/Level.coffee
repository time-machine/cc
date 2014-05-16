CocoModel = require './CocoModel'

module.exports = class Level extends CocoModel
  @className: 'Level'
  urlRoot: '/db/level'

  serialize: (supermodel) -> console.log 'TD: serialize'

  dimensions: -> console.log 'TD: dimensions'

  getReferencedModels: (data, schema, path='/') ->
    models = super data, schema, path
    if path.match(/\/system\/\d+\/config\//) and data?.indieSprites?.length
      console.log 'TD: getReferencedModels system'
    else if path is '/'
      console.log 'TD: getReferencedModels /'
    models
