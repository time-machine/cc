ThangState = require './thang_state'
{thangNames} = require './names'

module.exports = class Thang
  @className: 'Thang'
  @nextID: (spriteName) ->
    Thang.lastIDNums ?= {}
    names = thangNames[spriteName]
    if names
      console.log 'TD: nextID names'
    else
      Thang.lastIDNums[spriteName] = if Thang.lastIDNums[spriteName]? then Thang.lastIDNums[spriteName] + 1 else 0
      id = spriteName + (Thang.lastIDNums[spriteName] or '')
    id

  @resetThangIDs: -> console.log 'TD: resetThangIDs'

  constructor: (@world, @spriteName, @id) ->
    @spriteName ?= @constructor.className
    @id ?= @constructor.nextID @spriteName
    @addTrackedProperties ['exists', 'boolean'] # TODO: move into System/Components, too?

  updateRegistration: -> console.log 'TD: updateRegistration'

  publishNote: (channel, event) -> console.log 'TD: publishNote'

  # [prop, type]s of properties which have values tracked across WorldFrames. Also call keepTrackedProperty some non-expensive time when you change it or it will be skipped.
  addTrackedProperties: (props...) ->
    @trackedPropertiesKeys ?= []
    @trackedPropertiesTypes ?= []
    @trackedPropertiesUsed ?= []
    for [prop, type] in props
      unless type in ThangState.trackedPropertyTypes
        # How should errors for busted Components work? We can't recover from this and run the world.
        console.log 'TD: addTrackedProperties throw'
      oldPropIndex = @trackedPropertiesKeys.indexOf prop
      if oldPropIndex is -1
        @trackedPropertiesKeys.push prop
        @trackedPropertiesTypes.push type
        @trackedPropertiesUsed.push false
      else
        console.log 'TD: addTrackedProperties'

  keepTrackedProperty: (prop) -> console.log 'TD: keepTrackedProperty'

  addTrackedFinalProperties: (props...) -> console.log 'TD: addTrackedFinalProperties'

  getState: -> console.log 'TD: getState'

  setState: (state) -> console.log 'TD: setState'

  toString: -> console.log 'TD: toString'

  appendMethod: (methodName, newMethod) -> console.log 'TD: appendMethod'

  getMethodSource: (methodName) -> console.log 'TD: getMethodSource'

  serialize: -> console.log 'TD: serialize'

  @deserialize: (o, world, classMap) -> console.log 'TD: deserialize'
