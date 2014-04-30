CocoClass = require 'lib/CocoClass'

# Sprite: EaselJS-based view/controller for Thang model
module.exports = CocoSprite = class CocoSprite extends CocoClass
  #
  constructor: (@thangType, options) ->
    console.log 'TD: constructor', @thangType, options
