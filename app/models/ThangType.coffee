CocoModel = require './CocoModel'

module.exports = class ThangType extends CocoModel
  @className: 'ThangType'
  urlRoot: '/db/thang.type'
  building: 0

  initialize: ->
    super()
    @setDefaults()
    @on 'sync', @setDefaults
    @spriteSheets = {}

  setDefaults: ->
    @resetRawData() unless @get('raw')

  resetRawData: ->
    @set('raw', {shapes:{}, containers:{}, animations:{}})

  resetSpriteSheetCache: -> console.log 'TD: resetSpriteSheetCache'

  getActions: -> console.log 'TD: getActions'

  getSpriteSheet: (options) -> console.log 'TD: getSpriteSheet'

  getPortrait: (spriteOptionsOrKey, size=100) -> console.log 'TD: getPortrait'
