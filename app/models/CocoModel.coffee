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
      console.log 'TD: initialize'
    else
      @loadSchema()
    @once 'sync', @onLoaded

  type: -> console.log 'TD: type'

  onLoaded: => console.log 'TD: onLoaded'

  loadSchema: ->
    unless @constructor.schema
      # child prototype prop (available after class is initialized) is prop with
      # `x: (e.g. urlRoot:)` format in file
      # they are accessable with `@x (e.g. @urlRoot)`
      # if the prop is not found in child class then search it in parent class
      @constructor.schema = new CocoSchema(@urlRoot)
      @constructor.schema.fetch()

    @constructor.schema.on 'sync', =>
      @constructor.schema.loaded = true
      @addSchemaDefaults()
      @markToRevert
      @trigger 'schema-loaded'

  # @method (direct method) can access @attr (direct attr) of class
  @hasSchema: -> return @schema?.loaded
  schema: -> console.log 'TD: schema'

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

  getReferenceModels: (data, schema, path='/') -> console.log 'TD: getReferenceModels'

module.exports = CocoModel
