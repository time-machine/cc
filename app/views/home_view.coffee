View = require 'views/kinds/RootView'
template = require 'templates/home'

module.exports = class HomeView extends View
  id: 'home-view'
  template: template

  events:
    'hover #beginner-campaign': 'onHover'

  onHover: (e) ->
    console.log 'TD: onHover', e
