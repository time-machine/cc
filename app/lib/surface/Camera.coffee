CocoClass = require 'lib/CocoClass'

# If I were the kind of math major who remembered his math, this would all be done with matrix transforms.

d2r = (degrees) -> degrees / 180 * Math.PI

module.exports = class Camera extends CocoClass
  #
  # TODO: Fix tests to not use mainLayer
  constructor: (@canvasWidth, @canvasHeight, andle=Math.asin(0.75), hFOV=d2r(30)) ->
    super()
    console.log 'TD: constructor'
