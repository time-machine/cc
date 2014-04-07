app = require 'application'

$ ->
  app.initialize()
  Backbone.history.start({pushState:true})
  # TODO
