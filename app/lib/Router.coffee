application = require 'application'

module.exports = class CocoRouter extends Backbone.Router
  subscribe: ->
    Backbone.Mediator.subscribe 'gapi-loaded', @onGPlusAPILoaded, @
    Backbone.Mediator.subscribe 'router:navigate', @onNavigate, @

  routes:
    # every abnormla view gets listed here
    '': 'home'

    # db and files url call the server directly
    'db/*path': 'routeToServer'
    'file/*path': 'routeToServer'

    # most go through here
    '*name': 'general'

  home: -> @openRoute('home')

  general: ->
    console.log 'TD: general'

  cache: {}
  openRoute: (route) ->
    route = route.split('?')[0]
    route = route.split('#')[0]
    view = @getViewFromCache(route)
    console.log 'TD: openRoute', view

  onGPlusAPILoaded: =>
    console.log 'TD: onGPlusAPILoaded'

  getViewFromCache: (route) ->
    if route of @cache
      console.log 'TD: getViewFromCache1', route
    view = @getView(route)
    console.log 'TD: getViewFromCache', view

  getView: (route, suffix='_view') ->
    console.log 'TD: getView', route

  initialize: ->
    @cache = {}
    # http://nerds.airbnb.com/how-to-add-google-analytics-page-tracking-to-57536
    @bind 'route', @_trackPageView

  _trackPageView: ->
    console.log 'TD: _trackPageView'

  onNavigate: (e) ->
    console.log 'TD: onNavigate', e

  routeToServer: (e) ->
    console.log 'TD: routeToServer', e
