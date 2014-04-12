CocoModel = require './CocoModel'

module.exports = class ThangType extends CocoModel
  @className: 'ThangType'

  initialize: ->
    super()
    console.log 'TD: initialize', @
