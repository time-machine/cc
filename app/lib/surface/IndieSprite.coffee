CocoSprite = require 'lib/surface/CocoSprite'

module.exports = IndieSprite = class IndieSprite extends CocoSprite
  notOfThisWorld: true
  #
  constructor: (thangType, options) ->
    console.log 'TD: constructor', thangType, options
