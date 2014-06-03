CocoModel = require('./CocoModel')

module.exports = class LevelSystem extends CocoModel
  @className: 'LevelSystem'
  urlRoot: '/db/level.system'

  onLoaded: =>
    super()
    console.log 'TD: onLoaded set js' unless @get 'js'

  getDependencies: (allSystems) -> console.log 'TD: getDependencies'
