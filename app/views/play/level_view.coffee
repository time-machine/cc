View = require 'views/kinds/RootView'
template = require 'templates/play/level'
{me} = require 'lib/auth'

LoadingScreen = require 'lib/LoadingScreen'

# tools
LevelLoader = require 'lib/LevelLoader'

PROFILE_ME = false

module.exports = class PlayLevelView extends View
  id: 'level-view'
  template: template
  cache: false
  shortcutsEnabled: true
  startsLoading: true
  isEditorPreview: false

  subscriptions:
    'level-set-volume': (e) -> console.log 'TD: level-set-volume'
    'level-show-victory': 'onShowVictory'
    'restart-level': 'onRestartLevel'
    'level-highlight-dom': 'onHighlightDom'
    'end-level-highlight-dom': 'onEndHighlight'
    'level-focus-dom': 'onFocusDom'
    'level-disable-controls': 'onDisableControls'
    'level-enable-controls': 'onEnableControls'
    'god:infinite-loop': 'onInfiniteLoop'
    'bus:connected': 'onBusConnected'
    'level-reload-from-data': 'onLevelReloadFromData'
    'play-next-level': 'onPlayNextLevel'
    'edit-wizard-settings': 'showWizardSettingsModal'
    'surface:world-set-up': 'onSurfaceSetUpNewWorld'
    'level:session-will-save': 'onSessionWillSave'

  events:
    'click #level-done-butotn': 'onDonePressed'

  constructor: (options, @levelId) ->
    console.profile?() if PROFILE_ME
    super options
    if not me.get('hourOfCode') and @getQueryVariable 'hour_of_code'
      console.log 'TD: constructor hourOfCode'

    @isEditorPreview = @getQueryVariable 'dev'
    sessionID = @getQueryVariable 'session'
    @levelLoader = new LevelLoader(@levelId, @supermodel, sessionID)
    @levelLoader.once 'ready-to-init-world', @onReadyToInitWorld

    $(window).on('resize', @onWindowResize)
    @supermodel.once 'error', =>
      msg = $.i18n.t('play_level.level_load_error', defaultValue: "Level could not be loaded.")
      @$el.html('<div class="alert">' + msg + '</div>')
    @saveScreenshot = _.throttle @saveScreenshot, 30000

  getRenderData: ->
    c = super()
    c.world = @world
    c

  afterRender: ->
    window.onPlayLevelViewLoaded? @ # still a hack
    @loadingScreen = new LoadingScreen(@$el.find('canvas')[0])
    @loadingScreen.show()
    super()

  onReadyToInitWorld: => console.log 'TD: onReadyToInitWorld'

  onSupermodelLoadedOne: => console.log 'TD: onSupermodelLoadedOne'

  afterInsert: ->
    super()

  onLevelReloadFromData: (e) -> console.log 'TD: onLevelReloadFromData'

  onWindowResize: (s...) -> console.log 'TD: onWindowResize'

  onDisableControls: (e) => console.log 'TD: onDisableControls'

  onEnableControls: (e) => console.log 'TD: onEnableControls'

  onDonePressed: => console.log 'TD: onDonePressed'

  onShowVictory: (e) => console.log 'TD: onShowVictory'

  onRestartLevel: -> console.log 'TD: onRestartLevel'

  onInfiniteLoop: (e) -> console.log 'TD: onInfiniteLoop'

  onPlayNextLevel: => console.log 'TD: onPlayNextLevel'

  onHighlightDom: (e) => console.log 'TD: onHighlightDom'

  onFocusDom: (e) => console.log 'TD: onFocusDom'

  onEndHighlight: => console.log 'TD: onEndHighlight'

  onSurfaceSetUpNewWorld: -> console.log 'TD: onSurfaceSetUpNewWorld'

  onBusConnected: -> console.log 'TD: onBusConnected'

  onSessionWillSave: (e) -> console.log 'TD: onSessionWillSave'

  # Throttles
  saveScreenshot: (session) => console.log 'TD: saveScreenshot', session

  destroy: -> console.log 'TD: destroy'
