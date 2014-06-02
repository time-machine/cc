CocoModel = require('./CocoModel')

module.exports = class LevelComponent extends CocoModel
  @className = 'LevelComponent'
  urlRoot: '/db/level.component'

  onLoaded: =>
    super()
    console.log 'TD: onLoaded set js' unless @get 'js'

  getDependencies: (allComponents) -> console.log 'TD: getDependencies'
