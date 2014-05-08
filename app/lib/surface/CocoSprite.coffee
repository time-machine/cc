CocoClass = require 'lib/CocoClass'
SpriteBuilder = require 'lib/sprites/SpriteBuilder' # TOFIX: unused?

# Sprite: EaselJS-based view/controller for Thang model
module.exports = CocoSprite = class CocoSprite extends CocoClass
  thangType: null # ThangType instance

  displayObject: null
  imageObject: null

  healthBar: null
  marks: null
  labels: null

  options:
    resolutionFactor: 4
    groundLayer: null
    textLayer: null
    floatingLayer: null
    frameRateFactor: 1 # TODO: use or lose?
    thang: null
    camera: null
    spriteSheetCache: null
    showInvisible: false

  flipped: false
  flippedCount: 0
  originalScaleX: null
  originalScaleY: null
  actionQueue: null
  actions: null
  rotation: 0

  # ACTION STATE
  # Actions have relations. If you say 'move', 'move_side' may play because of a direction
  # relationship, and if you say 'cast', 'cast_begin' may happen first, or 'cast_end' after.
  currentRootAction: null # action that, in general, is playing or will play
  currentAction: null # related action that is right now playing

  subscriptions:
    'level-sprite-dialogue': 'onDialogue'
    'level-sprite-clear-dialogue': 'onClearDialogue'
    'level-set-letterbox': 'onSetLetterbox'

  constructor: (@thangType, options) ->
    super()
    @options = _.extend(_.cloneDeep(@options), options)
    @setThang @options.thang
    console.error @toString(), 'has no ThangType!' unless @thangType
    @actionQueue = []
    @marks = {}
    @labels = {}
    @actions = @thangType.getActions()
    @buildFromSpriteSheet @buildSpriteSheet()

  destroy: ->
    super()
    console.log 'TD: destroy'

  toString: -> "<CocoSprite: #{@thang?.id}>"

  spriteSheetKey: -> console.log 'TD: spriteSheetKey'

  buildSpriteSheet: -> @thangType.getSpriteSheet @options

  buildFromSpriteSheet: (spriteSheet) ->
    if spriteSheet
      sprite = new createjs.Sprite(spriteSheet)
    else
      console.log 'TD: buildFromSpriteSheet x'
    sprite.scaleX = sprite.scaleY = 1 / @options.resolutionFactor
    if @thangType.get('name') in ['Dungeon Floor', 'Grass', 'Goal Trigger', 'Obstacle'] # temp, until these are re-exported with perspective
      console.log 'TD: buildFromSpriteSheet thangType'
    @displayObject = new createjs.Container()
    @imageObject = sprite
    @displayObject.addChild(sprite)
    @addHealthBar()
    @configureMouse()
    # TODO: generalize this later?
    @originalScaleX = sprite.scaleX
    @originalScaleY = sprite.scaleY
    @displayObject.sprite = @
    @displayObject.layerPriority = @thangType.get 'layerPriority'
    @displayObject.name = @thang?.spriteName or @thangType.get 'name'
    @imageObject.on 'animationend', @onActionEnd

  onActionEnd: (e) => console.log 'TD: onActionEnd'

  update: -> console.log 'TD: update'

  cache: -> console.log 'TD: cache'

  configureMouse: ->
    console.log 'TD: configureMouse isSelectable' if @thang?.isSelectable
    @displayObject.mouseEnabled = @displayObject.mouseChildren = false unless @thang?.isSelectable or @thang?.isLand
    if @displayObject.mouseEnabled
      console.log 'TD: configureMouse mouseEnabled'

  onSetLetterbox: (e) -> console.log 'TD: onSetLetterbox'

  addHealthBar: ->
    console.log 'TD: addHealthBar parent' if @healthBar?.parent
    return unless @thang?.health? and 'health' in (@thang?.hudProperties ? [])
    console.log 'TD: addHealthBar'

  setHighlight: (to, delay) -> console.log 'TD: setHighlight'

  setDimmed: (@dimmed) -> console.log 'TD: setDimmed'

  setThang: (@thang) ->
    @options.thang = @thang

  setDebug: (debug) -> console.log 'TD: setDebug'

  getAverageDimension: -> console.log 'TD: getAverageDimension'

  isTalking: -> console.log 'TD: isTalking'

  onDialogue: (e) -> console.log 'TD: onDialogue'

  onClearDialogue: (e) -> console.log 'TD: onClearDialogue'

  setNameLabel: (name) -> console.log 'TD: setNameLabel'

  playSounds: (withDelay=true, volume=1.0) -> console.log 'TD: playSounds'
