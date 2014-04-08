module.exports = class CocoView extends Backbone.View
  # Setup, Teardown

  constructor: (options) ->
    console.log 'TD: constructor', arguments

  destroy: ->
    console.log 'TD: destroy'

  # View Rendering

  render: =>
    console.log 'TD: render'
