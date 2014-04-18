application = require 'application'
{me} = require 'lib/auth'

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

  general: (name) -> console.log 'TD: general', name

  cache: {}
  openRoute: (route) ->
    route = route.split('?')[0]
    route = route.split('#')[0]
    view = @getViewFromCache(route)
    @openView(view)

  openView: (view) ->
    @closeCurrentView()
    $('#page-container').empty().append view.el
    window.currentView = view
    @activateTab()
    @renderLoginButtons()
    console.log 'TD: openView', view.el

  onGPlusAPILoaded: => console.log 'TD: onGPlusAPILoaded'

  renderLoginButtons: ->
    $('.share-buttons').addClass('fade-in').delay(10000).removeClass('fade-in', 5000)
    console.log 'TD: renderLoginButtons' if FB? # Handles FB login and Like
    twttr?.widgets?.load()

    return unless gapi?.plusone?
    console.log 'TD: renderLoginButtons'

  getViewFromCache: (route) ->
    if route of @cache
      console.log 'TD: getViewFromCache route is key of cache', route
    view = @getView(route)
    @cache[route] = view unless view and view.cache is false
    return view

  getView: (route, suffix='_view') ->
    # iteratively breaks down the url places looking for the view
    # passing the broken off pieces as args. This way views like "resource/14394893"
    # will get passed to the resource view with arg "14394893"
    pieces = _.string.words(route, '/')

    # FIX: default max should be 0 as it's possible to have only 1 piece of route
    #      if default max to 1, the split loop will run additional one more time
    split = Math.max(1, pieces.length-1)

    while split > -1
      sub_route = _.string.join('/', pieces[0..split]...)
      path = "views/#{sub_route}#{suffix}"
      ViewClass = @tryToLoadModule(path)
      break if ViewClass
      split -= 1

    return @showNotFound() if not ViewClass
    args = pieces[split+1..]

    # e.g. route = 'home/alone/two' => ViewClass = 'HomeView', args = ['alone', 'two']
    view = new ViewClass({}, args...) # options, then any path fragment args
    view.render()

  tryToLoadModule: (path) ->
    try
      return require path
    catch error
      # FIX: why not use `error.message` instead of `error.toString()`
      if error.toString().search('Cannot find module "' + path + '" from') is -1
        throw error

  showNotFound: -> console.log 'TD: showNotFound'

  closeCurrentView: ->
    if window.currentModal?
      console.log 'TD: closeCurrentView currentModal', window.currentModal
    return unless window.currentView?
    console.log 'TD: closeCurrentView'

  activateTab: ->
    base = _.string.words(document.location.pathname[1..], '/')[0]
    $("ul.nav li.#{base}").addClass('active')

  initialize: ->
    @cache = {}
    # http://nerds.airbnb.com/how-to-add-google-analytics-page-tracking-to-57536
    @bind 'route', @_trackPageView

  _trackPageView: -> console.log 'TD: _trackPageView'

  onNavigate: (e) -> console.log 'TD: onNavigate', e

  routeToServer: (e) -> console.log 'TD: routeToServer', e
