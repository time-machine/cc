CocoModel = require './CocoModel'

module.exports = class ThangType extends CocoModel
  @className: 'ThangType'
  urlRoot: '/db/thang.type'

  initialize: ->
    super()
    @setDefaults()
    @on 'sync', @setDefaults
    @spriteSheets = {}

  setDefaults: ->
    @resetRawData() unless @get('raw')

  resetRawData: ->
    @set('raw', {shapes:{}, containers:{}, animations:{}})
