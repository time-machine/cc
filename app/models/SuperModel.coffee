class SuperModel
  constructor: ->
    @models = {}
    @collections = {}
    _.extend(@, Backbone.Events)

module.exports = SuperModel
