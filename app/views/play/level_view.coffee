View = require 'views/kinds/RootView'
template = require 'templates/play/level'
{me} = require 'lib/auth'

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
    console.log 'TD: constructor'

  getRenderData: -> console.log 'TD: getRenderData'

  afterRender: -> console.log 'TD: afterRender'

  onSupermodelLoadedOne: => console.log 'TD: onSupermodelLoadedOne'

  afterInsert: -> console.log 'TD: afterInsert'

  onLevelReloadFromData: (e) -> console.log 'TD: onLevelReloadFromData'

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

  destroy: -> console.log 'TD: destroy'
