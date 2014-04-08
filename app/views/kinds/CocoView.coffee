SuperModel = require 'models/SuperModel'

module.exports = class CocoView extends Backbone.View
  # Setup, Teardown

  constructor: (options) ->
    @supermodel ?= options?.supermodel or new SuperModel()
    console.log 'TD: constructor', @supermodel

  destroy: ->
    console.log 'TD: destroy'

  # View Rendering

  render: =>
    console.log 'TD: render'
