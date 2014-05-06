CocoModel = require './CocoModel'

module.exports = class ThangType extends CocoModel
  @className: 'ThangType'
  urlRoot: '/db/thang.type'
  building: 0

  initialize: ->
    super()
    @setDefaults()
    # the sync event will be received by the parent first, then here
    @on 'sync', -> @setDefaults
    @spriteSheets = {}

  setDefaults: ->
    @resetRawData() unless @get('raw')

  resetRawData: ->
    @set('raw', {shapes:{}, containers:{}, animations:{}})

  requiredRawAnimations: ->
    required = []
    for name, action of @get('actions')
      allActions = [action].concat(_.values (action.relatedActions ? {}))
      for a in allActions when a.animation
        scale = if name is 'portrait' then a.scale or 1 else a.scale or @get('scale') or 1
        animation = {animation: a.animation, scale: scale}
        animation.portrait = name is 'portrait'
        unless _.find(required, (r) -> _.isEqual r, animation)
          required.push animation
    required

  resetSpriteSheetCache: -> console.log 'TD: resetSpriteSheetCache'

  getActions: ->
    return @actions or @buildActions()

  buildActions: ->
    @actions = _.cloneDeep(@get('actions'))
    for name, action of @actions
      action.name = name
      for relatedName, relatedAction of action.relatedActions ? {}
        relatedAction.name = action.name + '_' + relatedName
        @actions[relatedAction.name] = relatedAction
    @actions

  getSpriteSheet: (options) ->
    options = @fillOptions options
    key = @spriteSheetKey(options)
    return @spriteSheets[key] or @buildSpriteSheet(options)

  fillOptions: (options) ->
    options ?= {}
    options = _.clone options
    options.resolutionFactor ?= 4
    options.async ?= false
    options

  buildSpriteSheet: (options) ->
    options = @fillOptions options
    @buildActions() if not @actions
    unless @requiredRawAnimations().length or _.find @actions, 'container'
      console.log 'TD: buildSpriteSheet no animation'
    console.log 'TD: buildSpriteSheet'

  spriteSheetKey: (options) ->
    "#{@get('name')} - #{options.resolutionFactor}"

  getPortrait: (spriteOptionsOrKey, size=100) -> console.log 'TD: getPortrait'
