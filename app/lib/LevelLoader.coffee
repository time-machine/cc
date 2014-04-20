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
    console.log 'TD: constructor', @levelID, @supermodel, @sessionID

  # Session Loading

  loadSession: ->
    url = if @sessionID then "/db/level_session/#{@sessionID}" else "/db/level/#{@levelID}/session"
    @session = new LevelSession()
    console.log 'TD: loadSession', url, @session

  # Dynamic sound loading

  loadSoundsForWorld: (e) -> console.log 'TD: loadSoundsForWorld'

  destroy: -> console.log 'TD: destroy'
