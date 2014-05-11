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

  ##################################################
  # QUEUEING AND PLAYING ACTIONS

  queueAction: (action) ->
    # The normal way to have an action play
    action = @actions[action] if _.isString(action)
    action ?= @actions.idle
    @actionQueue = []
    @actionQueue.push @currentRootAction.relatedActions.end if @currentRootAction?.relatedActions?.end
    @actionQueue.push action.relatedActions.begin if action.relatedActions?.begin
    @actionQueue.push action
    @currentRootAction = action
    @playNextAction()

  onActionEnd: (e) => @playNextAction()

  playNextAction: ->
    @playAction(@actionQueue.splice(0,1)[0]) if @actionQueue.length

  playAction: (action) ->
    @currentAction = action
    console.log 'TD: playAction updateActionDirection' unless action.animation or action.container
    m = if action.container then 'gotoAndStop' else 'gotoAndPlay'
    @imageObject[m] action.name
    @imageObject.framerate = action.framerate or 20
    reg = @getOffset 'registration'
    @imageObject.regX = -reg.x
    @imageObject.regY = -reg.y
    if @currentRootAction.name is 'move'
      console.log 'TD: playAction'

  update: ->
    # Gets the sprite to reflect what the current state of the thangs and surface are
    @updatePosition()
    @updateScale()
    @updateAlpha()
    @updateRotation()
    @updateAction()
    @updateStats()
    @updateMarks()
    @updateLabels()

  cache: -> console.log 'TD: cache'

  updatePosition: ->
    return unless @thang?.pos and @options.camera?
    console.log 'TD: updatePosition'

  updateScale: ->
    if @thangType.get('matchWorldDimensions') and @thang
      console.log 'TD: updateScale'
    scaleX = if @getActionProp 'flipX' then -1 else 1
    scaleY = if @getActionProp 'flipY' then -1 else 1
    scaleFactor = @thang.scaleFactor ? 1
    @imageObject.scaleX = @originalScaleX * scaleX * scaleFactor
    @imageObject.scaleY = @originalScaleY * scaleY * scaleFactor

  updateAlpha: ->
    return unless @thang?.alpha?
    console.log 'TD: updateAlpha'

  updateRotation: (imageObject) ->
    rotationType = @thangType.get('rotationType')
    return if rotationType is 'fixed'
    rotation = @getRotation()
    imageObject ?= @imageObject
    return imageObject.rotation = rotation if not rotationType
    @updateIsometricRotation(rotation, imageObject)

  getRotation: ->
    return @rotation if not @thang?.rotation
    console.log 'TD: getRotation'

  updateIsometricRotation: (rotation, imageObject) ->
    action = @currentRootAction
    return unless action
    console.log 'TD: updateIsometricRotation'

  updateAction: ->
    action = @determineAction()
    isDifferent = action isnt @currentRootAction
    console.error 'action is', action, 'for', @thang?.id, 'from', @currentRootAction, @thang.action, @thang.getActionName?() if not action and @thang?.actionActivated and @thang.id is 'Artillery'
    @queueAction(action) if isDifferent or (@thang?.actionActivated and action.name isnt 'move')
    @updateActionDirection()

  determineAction: ->
    action = null
    action = @thang.getActionName() if @thang?.acts
    action ?= @currentRootAction.name if @currentRootAction?
    action ?= 'idle'
    action = null unless @actions[action]?
    return null unless action
    action = 'break' if @actions.break? and @thang?.erroredOut
    action = 'die' if @actions.die? and @thang?.health? and @thang.health <= 0
    @actions[action]

  updateActionDirection: (@wallGrid=null) ->
    # wallGrid is only needed for wall grid face updates; should refactor if this works
    return unless action = @getActionDirection()
    console.log 'TD: updateActionDirection'

  getActionDirection: (rootAction=null) ->
    rootAction ?= @currentRootAction
    # TOFIX: will never return null as empty object is always truthy
    return null unless relatedActions = rootAction?.relatedActions ? {}
    rotation = @getRotation()
    if relatedActions['111111111111'] # has grid-surrounding-wall based actions
      console.log 'TD: getActionDirection relatedActions'
    value = Math.abs(rotation)
    direction = null
    direction = 'side' if value <=45 or value >= 135
    direction = 'fore' if 135 > rotation > 45
    direction = 'back' if -135 < rotation < -45
    relatedActions[direction]

  updateStats: ->
    if bar = @healthBar
      console.log 'TD: updateStats'

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

  getActionProp: (prop, subProp, def=null) ->
    # Get a property or sub-property from an action, falling back to ThangType
    for val in [@currentAction?[prop], @thangType.get(prop)]
      val = val[subProp] if val? and subProp
      return val if val?
    def

  getOffset: (prop) ->
    # Get the proper offset from either the current action or the ThangType
    def = x: 0, y: {registration: 0, torso: -50, mouth: -60, aboveHead: -100}[prop]
    pos = @getActionProp 'positions', prop, def
    pos = x: pos.x, y: pos.y
    scale = @getActionProp 'scale', null, 1
    scale *= @options.resolutionFactor if prop is 'registration'
    pos.x *= scale
    pos.y *= scale
    pos

  updateMarks: ->
    return unless @options.camera
    console.log 'TD: updateMarks'

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

  updateLabels: ->
    return unless @thang
    blurb = if @thang.health <= 0 then null else @thang.sayMessage # Dead men tell no tales
    console.log 'TD: updateLabels blurb' if blurb
    if @labels.say?.setText blurb
      console.log 'TD: updateLabels say'
    console.log 'TD: updateLabels labels' for name, label of @labels

  playSounds: (withDelay=true, volume=1.0) -> console.log 'TD: playSounds'
