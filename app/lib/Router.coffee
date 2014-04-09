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

  general: (name) ->
    console.log 'TD: general', name

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
    # iteratively breaks down the url places looking for the view
    # passing the broken off pieces as args. This way views like "resource/14394893"
    # will get passed to the resource view with arg "14394893"
    pieces = _.str.words(route, '/')

    # FIX: default max should be 0 as it's possible to have only 1 piece of route
    #      if default max to 1, the split loop will run additional one more time
    split = Math.max(1, pieces.length-1)

    while split > -1
      sub_route = _.str.join('/', pieces[0..split]...)
      path = "views/#{sub_route}#{suffix}"
      ViewClass = @tryToLoadModule(path)
      break if ViewClass
      split -= 1

    return @showNotFound() if not ViewClass
    args = pieces[split+1..]

    # options, then any path fragment args
    # e.g. route = 'home/alone/two' => ViewClass = 'HomeView', args = ['alone', 'two']
    view = new ViewClass({}, args...)

    view.render()

  tryToLoadModule: (path) ->
    try
      return require path
    catch error
      # FIX: why not use `error.message` instead of `error.toString()`
      if error.toString().search('Cannot find module "' + path + '" from') is -1
        throw error

  showNotFound: ->
    console.log 'TD: showNotFound'

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
