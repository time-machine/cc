class SuperModel
  constructor: ->
    @models = {}
    @collections = {}
    _.extend(@, Backbone.Events)

  populateModel: (model) -> console.log 'TD: populateModel'

  getModel: (ModelClass_or_url, id) ->
    console.log 'TD: getModel isString' if _.isString(ModelClass_or_url)
    m = new ModelClass_or_url(_id: id)
    return @getModelByURL(m.url())

  getModelByURL: (modelURL) ->
    return @models[modelURL] or null

  getModelByOriginalAndMajorVersion: (ModelClass, original, majorVersion=0) ->
    console.log 'TD: getModelByOriginalAndMajorVersion'

  getModels: (ModelClass) -> console.log 'TD: getModels'

  getCollection: (collection) -> console.log 'TD: getCollection'

  addCollection: (collection) -> console.log 'TD: addCollection'

module.exports = SuperModel
