CocoClass = require 'lib/CocoClass'

module.exports = class LoadingScreen extends CocoClass
  progress: 0

  constructor: (canvas) ->
    super()
    @width = canvas.width
    @height = canvas.height
    @stage = new createjs.Stage(canvas)

  subscriptions:
    'level-loader:progress-changed': 'onLevelLoaderProgressChanged'

  show: ->
    console.log 'TD: show screen' if @screen
    @screen = @makeScreen()
    console.log 'show', @screen

  hide: -> console.log 'hide'

  makeScreen: ->
    c = new createjs.Container()
    c.addChild(@makeLoadBackground())
    console.log 'TD: makeScreen', c

  makeLoadBackground: ->
    g = new createjs.Graphics()
    g.beginFill(createjs.Graphics.getRGB(30,30,60))
    g.drawRoundRect(0, 0, @width, @height, 0.0)
    s = new createjs.Shape(g)
    s.y = 0
    s.x = 0
    s

  onLevelLoaderProgressChanged: (e) -> console.log 'TD: onLevelLoaderProgressChanged'

  destroy: -> console.log 'TD: destroy'
