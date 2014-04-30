View = require 'views/kinds/RootView'
template = require 'templates/home'
WizardSprite = require 'lib/surface/WizardSprite'
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
    # the sync event is actioned at here after parent(CoCoModel, then ThangType) has acted with it
    @wizardType.once 'sync', @initCanvas

  initCanvas: =>
    @stage = new createjs.Stage($('#beginner-campaign canvas', @$el)[0])
    @createWizard -10, 2, 2.6
    console.log 'TD: initCanvas'

  createWizard: (x=0, y=0, scale=1.0) ->
    spriteOptions = thangID: 'Beginner Wizard', resolutionFactor: scale
    @wizardSprite = new WizardSprite @wizardType, spriteOptions
    console.log 'TD: createWizard', @wizardSprite

  onHover: (e) -> console.log 'TD: onHover', e

  willDisapper: -> console.log 'TD: willDisapper'

  didReappear: -> console.log 'TD: didReappear'
