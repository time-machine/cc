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
    super thangType, options

  makeIndieThang: (thangType, thangID, pos) ->
    @thang = thang = new Thang null, thangType.get('name'), thangID
    # Build needed results of what used to be Exists, Physical, Acts, and Selectable Components
    thang.exists = true
    thang.width = thang.height = thang.depth = 4
    thang.pos = pos ? @defaultPos()
    thang.pos.z ?= @defaultPos().z
    thang.rotation = 0
    thang.action = 'idle'
    thang.setAction = (action) -> thang.action = action
    thang.getActionName = -> thang.action
    thang.acts = true
    thang.isSelectable = true
    thang

  onNoteGroupStarted: => console.log 'TD: onNoteGroupStarted'
  onNoteGroupEnded: => console.log 'TD: onNoteGroupEnded'
  onMouseEvent: (e, ourEventName) -> console.log 'TD: onMouseEvent'
  defaultPos: -> x: -20, y: 20, z: @thang.depth / 2

  onMove: (e) -> console.log 'TD: onMove'
