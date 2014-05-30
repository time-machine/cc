CocoModel = require('./CocoModel')

module.exports = class LevelComponent extends CocoModel
  @className = 'LevelComponent'
  urlRoot: '/db/level.component'

  onLoaded: => console.log 'TD: onLoaded'

  getDependencies: (allComponents) -> console.log 'TD: getDependencies'
