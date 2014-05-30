mongoose = require('mongoose')
plugins = require('./plugin')
jsonschema = require('../schemas/level_system')

LevelSystemSchema = new mongoose.Schema {
  description: String
}, {strict: false}

LevelSystemSchema.plugin(plugins.NamedPlugin)
LevelSystemSchema.plugin(plugins.PermissionsPlugin)
LevelSystemSchema.plugin(plugins.VersionedPlugin)
LevelSystemSchema.plugin(plugins.SearchablePlugin, {searchable: ['name', 'description']})

LevelSystemSchema.pre 'init', (next) -> console.log 'TD: LevelSystemSchema pre init'

module.exports = LevelSystem = mongoose.model('level.system', LevelSystemSchema)
