Level = require 'models/Level'
CocoClass = require 'lib/CocoClass'
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
    console.log 'TD: constructor', @levelID, @supermodel, @sessionID

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
    console.log 'TD: loadLevelModels', @level.constructor.schema

  onSupermodelError: => console.log 'TD: onSupermodelError'

  onSupermodelLoadedOne: (e) => console.log 'TD: onSupermodelLoadedOne'

  onSupermodelLoadedAll: => console.log 'TD: onSupermodelLoadedAll'

  # Dynamic sound loading

  loadSoundsForWorld: (e) -> console.log 'TD: loadSoundsForWorld'

  destroy: -> console.log 'TD: destroy'
