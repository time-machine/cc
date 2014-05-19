class CocoSchema extends Backbone.Model
  constructor: (path, args...) ->
    super args...
    @urlRoot = path + '/schema'

window.CocoSchema = CocoSchema

class CocoModel extends Backbone.Model
  idAttribute: '_id'
  loaded: false
  loading: false
  @schema: null

  initialize: ->
    super()

    # class direct prop (available even class is not initialized) is prop with
    # `@x: (e.g. @className:)` format in file
    #
    # they are accessable with `@constructor.x (e.g. @constructor.className)`
    # or `ClassName.x (e.g. User.className)`, @constructor is same as child
    # class, User
    #
    # if the prop is not found in child class then search it in parent class
    if not @constructor.className
      console.error "#{@} needs a className set."
    @markToRevert()
    if @constructor.schema?.loaded
      @addSchemaDefaults()
    else
      @loadSchema()

    # sync is triggered when Backbone fetch child model from server.
    # e.g. `@wizardType.fetch()`
    @once 'sync', @onLoaded

  type: -> console.log 'TD: type'

  onLoaded: =>
    @onloaded = true
    @loading = false
    @markToRevert()

  loadSchema: ->
    unless @constructor.schema
      # child prototype prop (available after class is initialized) is prop with
      # `x: (e.g. urlRoot:)` format in file
      # they are accessable with `@x (e.g. @urlRoot)`
      # if the prop is not found in child class then search it in parent class
      @constructor.schema = new CocoSchema(@urlRoot)
      @constructor.schema.fetch() # trigger sync event which is listened by `@constructor.schema` below

    @constructor.schema.on 'sync', =>
      @constructor.schema.loaded = true
      @addSchemaDefaults()
      @markToRevert
      @trigger 'schema-loaded'

  # @method (direct method) can access @attr (direct attr) of class
  @hasSchema: -> return @schema?.loaded
  schema: -> return @constructor.schema

  validate: -> console.log 'TD: validate'

  save: (attrs, options) -> console.log 'TD: save'

  fetch: ->
    super()
    @loading = true

  markToRevert: ->
    @_revertAttributes = _.clone @attributes

  revert: -> console.log 'TD: revert'

  hasLocalChanges: -> console.log 'TD: hasLocalChanges'

  cloneNewMajorVersion: -> console.log 'TD: cloneNewMajorVersion'

  publish: -> console.log 'TD: publish'

  # this is triggered twice due to `Level` model is initialized twice by
  # `LevelLoader.coffee` > `loadLevelModels` >
  #     `@supermodel.getModel(xx, xx) or new Level _id: xx`
  #
  # TOFIX?
  addSchemaDefaults: ->
    return if @addedSchemaDefaults or not @constructor.hasSchema()
    @addedSchemaDefaults = true
    for prop, defaultValue of @constructor.schema.attributes.default or {}
      continue if @get(prop)?
      @set prop, defaultValue
    for prop, sch of @constructor.schema.attributes.properties or {}
      continue if @get(prop)?
      @set prop, sch.default if sch.default?

  getReferencedModels: (data, schema, path='/') ->
    # returns unfetched model shells for every referenced doc in this model
    # OPTIMIZE so that when loading models, it doesn't cause the site to stutter
    data ?= @attributes
    schema ?= @schema().attributes
    models = []

    if $.isArray(data) and schema.items?
      for subData, i in data
        models = models.concat(@getReferencedModels(subData, schema.items, path+i+'/'))

    if $.isPlainObject(data) and schema.properties?
      for key, subData of data
        continue unless schema.properties[key]
        models = models.concat(@getReferencedModels(subData, schema.properties[key], path+key+'/'))

    model = CocoModel.getReferencedModel data, schema
    models.push model if model
    return models

  @getReferencedModel: (data, schema) ->
    return null unless schema.links?
    linkObject = _.find schema.links, rel: 'db'
    return null unless linkObject
    return null if linkObject.href.match('thang_type') and not @isObjectID(data) # Skip loading hardcoded Thang Types for now (TODO)

    # not fully extensible, but we can worry about that later
    link = linkObject.href
    link = link.replace('{(original)}', data.original)
    link = link.replace('{(majorVersion)}', '' + (data.majorVersion ? 0))
    link = link.replace('{($)}', data)
    @getOrMakeModelFromLink(link)

  @getOrMakeModelFromLink: (link) ->
    makeUrlFunc = (url) -> -> url
    modelUrl = link.split('/')[2]
    modelModule = _.string.classify(modelUrl)
    modulePath = "models/#{modelModule}"
    window.loadedModels ?= {}

    try
      Model = require modulePath
      window.loadedModels[modulePath] = Model
    catch e
      # console.error 'could not laod model from link path', link, 'using path', modulePath
      return

    model = new Model()
    model.url = makeUrlFunc(link)
    return model

  @isObjectID: (s) ->
    s.length is 24 and s.match(/[a-z0-9]/gi)?.length is 24

module.exports = CocoModel
