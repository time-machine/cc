SuperModel = require 'models/SuperModel'
utils = require 'lib/utils'

classCount = 0
makeScopeName = -> "view-scope-#{classCount++}"
module.exports = class CocoView extends Backbone.View
  cache: true # signals to the router to keep this view around
  template: => ''

  events:
    'click a': 'toggleModal'
    'click button': 'toggleModal'

  subscriptions: {}
  shortcuts: {}

  # Setup, Teardown

  constructor: (options) ->
    @supermodel ?= options?.supermodel or new SuperModel()
    @options = options
    @subscriptions = utils.combineAncestralObject(@, 'subscriptions')
    @events = utils.combineAncestralObject(@, 'events')
    @scope = makeScopeName()
    @shortcuts = utils.combineAncestralObject(@, 'shortcuts')
    @subviews = {}
    @listenToShortcuts()
    # Backbone.Mediator handles subscription setup/teardown automatically
    super options

  destroy: ->
    console.log 'TD: destroy'

  # View Rendering

  render: =>
    console.log 'TD: render'

  # Modals

  toggleModal: (e) ->
    console.log 'TD: toggleModal', e

  # Shortcuts

  listenToShortcuts: (recurse) ->
    return unless key
    for shortcut, func of @shortcuts
      console.log 'TD: listenToShortcuts shortcut', shortcut
    if recurse
      console.log 'TD: listenToShortcuts recurse', recurse
