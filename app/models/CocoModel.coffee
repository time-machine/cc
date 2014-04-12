class CocoSchema extends Backbone.Model
  constructor: (path, args...) ->
    super args...
    @urlRoot = path + '/schema'

window.CocoSchema = CocoSchema

class CocoModel extends Backbone.Model
  idAttribute: '_id'
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

  onLoaded: =>
    console.log 'TD: onLoaded'

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

  # shorthand to access schema from child class (e.g. call `@schema()` at child class file)
  schema: -> return @constructor.schema

  validate: ->
    console.log 'TD: validate'

  save: (attrs, options) ->
    console.log 'TD: save'

  markToRevert: ->
    @_revertAttributes = _.clone @attributes

  addSchemaDefaults: ->
    return if @addedSchemaDefaults or not @constructor.hasSchema()
    @addedSchemaDefaults = true
    for prop, defaultValue of @constructor.schema.attributes.default or {}
      console.log 'TD: addSchemaDefaults', prop
    for prop, sch of @constructor.schema.attributes.properties or {}
      continue if @get(prop)?
      @set prop, sch.default if sch.default?

module.exports = CocoModel
