{me} = require 'lib/auth' # TOFIX: unused?
CocoSprite = require 'lib/surface/CocoSprite'
Camera = require './Camera' # TOFIX: unused?

module.exports = IndieSprite = class IndieSprite extends CocoSprite
  notOfThisWorld: true
  subscriptions:
    'level-sprite-move': 'onMove'
    'note-group-started': 'onNoteGroupStarted'
    'note-group-ended': 'onNoteGroupEnded'

  constructor: (thangType, options) -> console.log 'TD: constructor', thangType, options

  onNoteGroupStarted: => console.log 'TD: onNoteGroupStarted'
  onNoteGroupEnded: => console.log 'TD: onNoteGroupEnded'
  onMouseEvent: (e, ourEventName) -> console.log 'TD: onMouseEvent'

  onMove: (e) -> console.log 'TD: onMove'
