CocoClass = require 'lib/CocoClass'

# Sprite: EaselJS-based view/controller for Thang model
module.exports = CocoSprite = class CocoSprite extends CocoClass
  thangType: null # ThangType instance

  displayObject: null
  imageObject: null

  healthBar: null
  marks: null
  lables: null

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
    console.log 'TD: constructor', @thangType, options

  onSetLetterbox: (e) -> console.log 'TD: onSetLetterbox'

  onDialogue: (e) -> console.log 'TD: onDialogue'

  onClearDialogue: (e) -> console.log 'TD: onClearDialogue'
