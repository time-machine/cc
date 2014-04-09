View = require 'views/kinds/RootView'
template = require 'templates/home'

module.exports = class HomeView extends View
  id: 'home-view'
  template: template

  events:
    'hover #beginner-campaign': 'onHover'

  getRenderData: ->
    c = super()
    if $.browser
      console.log 'TD: getRenderData', $.browser
    else
      console.warn 'no more jquery browser version'
    c

  afterRender: ->
    super()
    console.log 'TD: afterRender home'

  onHover: (e) ->
    console.log 'TD: onHover', e
