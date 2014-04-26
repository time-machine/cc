Level = require 'models/Level'
CocoClass = require 'lib/CocoClass'
AudioPlayer = require 'lib/AudioPlayer'
LevelSession =  require 'models/LevelSession'

# This is an initial stab at unifying loading and setup into a single place which can
# monitor everything and keep a LoadingScreen visible overall progress.
#
# Would also like to incorporate into here:
#  * World Building
#  * Sprite map generation
#  * Connecting to Firebase

module.exports = class LevelLoader extends CocoClass
  spriteSheetsBuilt: 0
  spriteSheetsToBuild: 0

  subscriptions:
    'god:new-world-created': 'loadSoundsForWorld'

  constructor: (@levelID, @supermodel, @sessionID) ->
    super()
    @loadSession()
    @loadLevelModels()
    @loadAudio()
    @playJingle()
    setTimeout (=> @update()), 1 # lets everything else resove first

  playJingle: ->
    jingles = ['ident_1', 'ident_2']
    AudioPlayer.playInterfaceSound jingles[Math.floor Math.random() * jingles.length]

  # Session Loading

  loadSession: ->
    url = if @sessionID then "/db/level_session/#{@sessionID}" else "/db/level/#{@levelID}/session"
    @session = new LevelSession()
    @session.url = -> url
    @session.fetch()
    @session.once 'sync', @onSessionLoaded

  onSessionLoaded: => console.log 'TD: onSessionLoaded'

  # Supermodel (Level) Loading

  loadLevelModels: ->
    @supermodel.once 'loaded-all', @onSupermodelLoadedAll
    @supermodel.on 'loaded-one', @onSupermodelLoadedOne
    @supermodel.once 'error', @onSupermodelError
    @level = @supermodel.getModel(Level, @levelID) or new Level _id: @levelID

    @supermodel.shouldPopulate = (model) => console.log 'TD: shouldPopulate'

    @supermodel.populateModel @level

  onSupermodelError: =>
    msg = $.i18n.t('play_level.level_load_error',
      defaultValue: "Level could not be loaded.")
    # TOFIX: supermodel doesn't have el attribute, only view have it?
    console.log 'TD: onSupermodelError el' if @$el
    # @$el.html('<div class="alert">' + msg + '</div>')

  onSupermodelLoadedOne: (e) => console.log 'TD: onSupermodelLoadedOne'

  onSupermodelLoadedAll: => console.log 'TD: onSupermodelLoadedAll'

  # Things to do when either the Session of Supermodel load

  update: ->
    # @notifyProgress()
    console.log 'TD: LevelLoader update'

  # Initial Sound Loading
  loadAudio: ->
    AudioPlayer.preloadInterfaceSounds ['victory']

  # Dynamic sound loading

  loadSoundsForWorld: (e) -> console.log 'TD: loadSoundsForWorld'

  progress: -> console.log 'TD: progress'

  notifyProgress: ->
    Backbone.Mediator.publish 'level-loader:progress-changed', progress: @progress()
    console.log 'TD: notifyProgress'

  destroy: -> console.log 'TD: destroy'
