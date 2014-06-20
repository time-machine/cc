mongoose = require 'mongoose'
plugins = require './plugins'
jsonschema = require '../schemas/level'

LevelSchema = new mongoose.Schema({
  description: String
}, {strict: false})

LevelSchema.plugin(plugins.NamedPlugin)
LevelSchema.plugin(plugins.PermissionsPlugin)
LevelSchema.plugin(plugins.VersionedPlugin)
LevelSchema.plugin(plugins.SearchablePlugin, {searchable: ['name', 'description']})

LevelSchema.pre 'init', (next) ->
  return next() unless jsonschema.properties?
  for prop, sch of jsonschema.properties
    @set(prop, _.cloneDeep(sch.default)) if sch.default?
  next()

LevelSchema.post 'init', (doc) ->
  if _.isString(doc.get('nextLevel'))
    console.log 'TD: LevelSchema post init'

module.exports = Level = mongoose.model('level', LevelSchema)
