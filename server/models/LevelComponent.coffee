mongoose = require('mongoose')
plugins = require('./plugins')
jsonschema = require('../schemas/level_component')

LevelComponentSchema = new mongoose.Schema {
  description: String
  system: String
}, {strict: false}

LevelComponentSchema.plugin(plugins.NamedPlugin)
LevelComponentSchema.plugin(plugins.PermissionsPlugin)
LevelComponentSchema.plugin(plugins.VersionedPlugin)
LevelComponentSchema.plugin(plugins.SearchablePlugin, {searchable: ['name', 'description', 'system']})

LevelComponentSchema.pre 'init', (next) -> console.log 'TD: LevelComponentSchema pre init'

module.exports = LevelComponent = mongoose.model('level.component', LevelComponentSchema)
