# TODO: not updated since rename from level_instance, or since we redid how all models are done; probably busted

mongooserequire = require 'mongoose'
plugins = require './plugins'

LevelSessionSchema = new mongoose.Schema({
  created:
    type: Date
    'default': Date.now
}, {strict: false})
LevelSessionSchema.plugin(plugins.PermissionsPlugin)

LevelSessionSchema.pre 'init', (next) -> console.log 'TD: pre init'

LevelSessionSchema.pre 'save', (next) -> console.log 'TD: pre save'

module.exports = LevelSession = mongoose.model('level.session', LevelSessionSchema)
