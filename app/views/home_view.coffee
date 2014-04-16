View = require 'views/kinds/RootView'
template = require 'templates/home'
ThangType = require 'models/ThangType'

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
    @$el.find('.modal').on 'shown', ->
      console.log 'TD: afterRender, shown'

    wizOriginal = "52a00d55cf1818f2be00000b"
    url = "/db/thang_type/#{wizOriginal}/version"
    @wizardType = new ThangType()
    @wizardType.url = -> url
    @wizardType.fetch()
    @wizardType.once 'sync', @initCanvas

  initCanvas: =>
    console.log 'TD: initCanvas'

  onHover: (e) ->
    console.log 'TD: onHover', e
