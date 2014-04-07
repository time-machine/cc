CocoClass = require 'lib/CocoClass'

module.exports = GPlusHandler = class GPlusHandler extends CocoClass
  constructor: ->
    super()

  subscriptions:
    'gplus-logged-in': 'onGPlusLogin'

  onGPlusLogin: (e) =>
    console.log 'TD: onGPlusLogin', e

  destroy: ->
    console.log 'TD: destroy'
