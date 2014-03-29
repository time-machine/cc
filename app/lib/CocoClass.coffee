# Template for classes with common functions, like hooking into the Mediator
utils = require './utils'
classCount = 0
makeScopeName = -> "class-scope-#{classCount++}"

module.exports = class CocoClass
  subscriptions: {}
  shortcuts: {}

  # setup / teardown
  constructor: ->
    @subscriptions = utils.combineAncestralObject(@, 'subscriptions')
    @shortcuts = utils.combineAncestralObject(@, 'shortcuts')
    @listenToSubscriptions()
    @scope = makeScopeName()
    @listenToShortcuts()
    _.extend(@, Backbone.Events) if Backbone?

  # subscriptions
  listenToSubscriptions: ->
    # for initting subscriptions
    return unless Backbone?.Mediator?
    for channel, func of @subscriptions
      func = utils.normalizeFunc(func, @)
      Backbone.Mediator.subscribe(channel, func, @)

  # keymaster shortcuts
  listenToShortcuts: ->
    return unless key?
    for shortcut, func of @shortcuts
      func = utils.normalizeFunc(func, @)
      key(shortcut, @scope, _.bind(func, @))
