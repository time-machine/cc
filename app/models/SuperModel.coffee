class SuperModel
  constructor: ->
    @models = {}
    @collections = {}
    _.extend(@, Backbone.Events)

  populateModel: (model) ->
    @mustPopulate = model
    model.fetch() unless model.loaded or model.loading
    model.on('sync', @modelLoaded) unless model.loaded
    model.once('error', @modelErrored) unless model.loaded
    url = model.url()
    @models[url] = model unless @models[url]?
    console.log 'TD: populateModel' if model.loaded

  modelErrored: (model) =>
    @trigger 'error'

  modelLoaded: (model) =>
    schema = model.schema()
    console.log 'TD: modelLoaded loaded' unless schema.loaded
    refs = model.getReferencedModels(model.attributes, schema.attributes)
    refs = [] unless @mustPopulate is model or @shouldPopulate(model)
    console.log 'TD: modelLoaded'

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

  progress: ->
    total = 0
    loaded = 0

    for key, model of @models
      total += 1
      loaded += 1 if model.loaded

    return 1.0 unless total
    return loaded / total

  # TOFIX: remove redundant return as coffescript will auto return last statement
  finished: ->
    return @progress() == 1.0

module.exports = SuperModel
