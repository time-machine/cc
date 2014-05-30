CocoModel = require('./CocoModel')

module.exports = class LevelSystem extends CocoModel
  @className: 'LevelSystem'
  urlRoot: '/db/level.system'

  onLoaded: => console.log 'TD: onLoaded'

  getDependencies: (allSystems) -> console.log 'TD: getDependencies'
