CocoModel = require './CocoModel'

module.exports = class LevelSession extends CocoModel
  @className: 'LevelSession'
  urlRoot: '/db/level.session'

  initialize: ->
    super()
    console.log 'TD: initialize', @constructor.schema
    @on 'sync', (e) => console.log 'TD: initialize'

  updatePermissions: -> console.log 'TD: updatePermissions'

  getSourceFor: (spellKey) -> console.log 'TD: getSourceFor', spellKey
