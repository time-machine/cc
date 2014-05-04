{me} = require 'lib/auth' # TOFIX: unused?
Thang = require 'lib/world/thang'
CocoSprite = require 'lib/surface/CocoSprite'
Camera = require './Camera' # TOFIX: unused?

module.exports = IndieSprite = class IndieSprite extends CocoSprite
  notOfThisWorld: true
  subscriptions:
    'level-sprite-move': 'onMove'
    'note-group-started': 'onNoteGroupStarted'
    'note-group-ended': 'onNoteGroupEnded'

  constructor: (thangType, options) ->
    options.thang = @makeIndieThang thangType, options.thangID, options.pos
    console.log 'TD: constructor', options.thang

  makeIndieThang: (thangType, thangID, pos) ->
    @thang = thang = new Thang null, thangType.get('name'), thangID
    console.log 'TD: makeIndieThang', @thang

  onNoteGroupStarted: => console.log 'TD: onNoteGroupStarted'
  onNoteGroupEnded: => console.log 'TD: onNoteGroupEnded'
  onMouseEvent: (e, ourEventName) -> console.log 'TD: onMouseEvent'

  onMove: (e) -> console.log 'TD: onMove'
