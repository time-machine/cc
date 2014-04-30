IndieSprite = require 'lib/surface/IndieSprite'

module.exports = class WizardSprite extends IndieSprite
  ticker: 0
  #

  constructor: (thangType, options) ->
    console.log 'TD: constructor', thangType, options
