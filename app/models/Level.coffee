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
      # We also need to make sure we grab the Wizard ThangType and the Marks. Hackitrooooid!
      for [type, original] in [
        ['Wizard', '52a00d55cf1818f2be00000b']
        ['Highlight', '529f8fdbdacd325127000003']
        ['Selection', '52aa5f7520fccb0000000002']
        ['Target', '52b32ad97385ec3d03000001']
        ['Repair', '52bcc4591f766a891c000003']
      ]
        link = "/db/thang_type/#{original}/version"
        model = CocoModel.getOrMakeModelFromLink link
        models.push model if model
    models
