IndieSprite = require 'lib/surface/IndieSprite'
Camera = require './Camera' # TOFIX: unused?

module.exports = class WizardSprite extends IndieSprite
  ticker: 0

  # Wizard targets are constantly changing, so a simple tween doesn't work.
  # Instead, the wizard stores its origin point and the (possibly) moving target.
  # Then it figures out its current possition based on tween percentage and
  # those two points.
  tweenPercentage: 1.0
  originPos: null
  targetPos: null
  targetSprite: null
  reachedTarget: true
  spriteXOffset: 4 # meters from target sprite
  spriteYOffset: 0 # meters from target sprite
  spriteZOffset: 1 # meters from ground (in middle of float)

  subscriptions:
    'bus:player-states-changed': 'onPlayerStatesChanged'
    'me:synced': 'onMeSynced'
    'surface:sprite-selected': 'onSpriteSelected'
    'surface:ticked': 'onSurfaceTicked'
    'echo-self-wizard-sprite': 'onEchoSelfWizardSprite'
    'echo-all-wizard-sprites': 'onEchoAllWizardSprites'

  constructor: (thangType, options) -> console.log 'TD: constructor', thangType, options

  makeIndieThang: (thangType, thangID, pos) -> console.log 'TD: makeIndieThang'

  onPlayerStatesChanged: (e) -> console.log 'TD: onPlayerStatesChanged'

  onMeSynced: (e) -> console.log 'TD: onMeSynced'

  onSpriteSelected: (e) -> console.log 'TD: onSpriteSelected'

  animateIn: -> console.log 'TD: animateIn'
  animateOut: (callback) -> console.log 'TD: animateOut'

  setInitialState: (targetPos, @targetSprite) -> console.log 'TD: setInitialState'

  onEchoSelfWizardSprite: (e) -> console.log 'TD: onEchoSelfWizardSprite'
  onEchoAllWizardSprites: (e) -> console.log 'TD: onEchoAllWizardSprites'
  onSurfaceTicked: -> console.log 'TD: onSurfaceTicked'
  move: (pos, duration) -> console.log 'TD: move'

  updateIsometricRotation: (rotation, imageObject) -> console.log 'TD: updateIsometricRotation'

  updateMarks: -> console.log 'TD: updateMarks'
