{thangNames} = require './names'

module.exports = class Thang
  @className: 'Thang'
  @nextID: (spriteName) ->
    Thang.lastIDNums ?= {}
    names = thangNames[spriteName]
    console.log 'TD: nextID', names

  @resetThangIDs: -> console.log 'TD: resetThangIDs'

  constructor: (@world, @spriteName, @id) ->
    @spriteName ?= @constructor.className
    console.log 'TD: constructor', @constructor.nextID @spriteName

  updateRegistration: -> console.log 'TD: updateRegistration'

  publishNote: (channel, event) -> console.log 'TD: publishNote'

  keepTrackedProperty: (prop) -> console.log 'TD: keepTrackedProperty'

  addTrackedFinalProperties: (props...) -> console.log 'TD: addTrackedFinalProperties'

  getState: -> console.log 'TD: getState'

  setState: (state) -> console.log 'TD: setState'

  toString: -> console.log 'TD: toString'

  appendMethod: (methodName, newMethod) -> console.log 'TD: appendMethod'

  getMethodSource: (methodName) -> console.log 'TD: getMethodSource'

  serialize: -> console.log 'TD: serialize'

  @deserialize: (o, world, classMap) -> console.log 'TD: deserialize'
