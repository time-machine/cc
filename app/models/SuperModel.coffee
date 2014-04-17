class SuperModel
  constructor: ->
    @models = {}
    @collections = {}
    _.extend(@, Backbone.Events)

  populateModel: (model) -> console.log 'TD: populateModel'

  getModel: (ModelClass_or_url, id) -> console.log 'TD: getModel'

  getModelByOriginalAndMajorVersion: (ModelClass, original, majorVersion=0) ->
    console.log 'TD: getModelByOriginalAndMajorVersion'

  getModels: (ModelClass) -> console.log 'TD: getModels'

  getCollection: (collection) -> console.log 'TD: getCollection'

  addCollection: (collection) -> console.log 'TD: addCollection'

module.exports = SuperModel
