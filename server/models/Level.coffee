mongoose = require 'mongoose'
plugins = require './plugins'

LevelSchema = new mongoose.Schema({
  description: String
}, {strict: false})

LevelSchema.plugin(plugins.NamedPlugin)
LevelSchema.plugin(plugins.PermissionsPlugin)
LevelSchema.plugin(plugins.VersionedPlugin)
LevelSchema.plugin(plugins.SearchablePlugin, {searchable: ['name', 'description']})

LevelSchema.pre 'init', (next) -> console.log 'TD: pre init'

LevelSchema.post 'init', (doc) -> console.log 'TD: post init'

module.exports = Level = mongoose.model('level', LevelSchema)
