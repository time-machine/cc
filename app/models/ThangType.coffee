CocoModel = require './CocoModel'
SpriteBuilder = require 'lib/sprites/SpriteBuilder'

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
      return null if @.get('name') is 'Invisible'
      console.warn "Can't build a CocoSprite with no animations or containers!", @

    vectorParser = new SpriteBuilder(@)
    builder = new createjs.SpriteSheetBuilder()
    builder.padding = 2

    # First we add the frames from the raw animations to the sprite sheet builder
    framesMap = {}
    for animation in @requiredRawAnimations()
      name = animation.animation
      movieClip = vectorParser.buildMovieClip name
      if animation.portrait
        movieClip.nominalBounds = null
        movieClip.frameBounds = null
        pt = @actions.portrait.positions?.registration
        rect = new createjs.Rectangle(pt?.x/animation.scale or 0, pt?.y/animation.scale or 0, 100/animation.scale, 100/animation.scale)
        builder.addMovieClip(movieClip, rect, animation.scale)
      else
        builder.addMovieClip movieClip, null, animation.scale * options.resolutionFactor
      framesMap[animation.scale + '_' + name] = builder._animations[name].frames

    # Then we add real animations for our actions with our desired configuration
    for name, action of @actions when action.animation
      if name is 'portrait'
        scale = action.scale ? 1
      else
        scale = action.scale ? @get('scale') ? 1
      keptFrames = framesMap[scale + '_' + action.animation]
      if action.frames
        frames = action.frames
        frames - frames.split(',') if _.isString(frames)
        newFrames = (parseInt(f, 10) for f in frames)
        keptFrames = (f + keptFrames[0] for f in newFrames)
      action.frames = keptFrames # Keep generated frame numbers around
      next = true
      if action.goesTo
        console.log 'TD: buildSpriteSheet goesTo'
      else if action.loops is false
        next = false
      builder.addAnimation name, keptFrames, next

    # action
    #   container: "House_04"
    #   name: "portrait"
    #   positions: Object
    #     registration: Object
    #       x: 20
    #       y: 40
    #   scale: 0.6
    for name, action of @actions when action.container and not action.animation
      scale = options.resolutionFactor * (action.scale or @get('scale') or 1)
      s = vectorParser.buildContainerFromStore(action.container)
      if action.name is 'portrait'
        scale = action.scale or 1
        pt = action?.positions?.registration
        rect = new createjs.Rectangle(pt?.x/scale or 0, pt?.y/scale or 0, 100/scale, 100/scale)
        # frame = builder.addFrame(s, rect, scale)
        console.log 'TD: buildSpriteSheet frame'
      else
        console.log 'TD: buildSpriteSheet x portrait'
      console.log 'TD: buildSpriteSheet container'

    spriteSheet = null
    if options.async
      console.log 'TD: buildSpriteSheet async'
    else
      console.warn 'Building', @get('name'), 'and blocking the main thread. LevelLoader should have it built asynchronously instead.'
      spriteSheet = builder.build()
    @spriteSheets[@spriteSheetKey(options)] = spriteSheet
    spriteSheet

  spriteSheetKey: (options) ->
    "#{@get('name')} - #{options.resolutionFactor}"

  getPortrait: (spriteOptionsOrKey, size=100) -> console.log 'TD: getPortrait'
