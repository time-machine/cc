mongoose = require 'mongoose'
textSearch = require 'mongoose-text-search'

module.exports.NamedPlugin = (schema) ->
  schema.add({name: String, slug: String})
  schema.index({'slug': 1}, {unique: true, sparse: true, name: 'slug index'})

  schema.pre('save', (next) ->
    console.log 'TD: NamedPlugin save'
  )

module.exports.VersionedPlugin = (schema) ->
  schema.uses_coco_versions = true

  schema.add(
    version:
      major: {type: Number, 'default': 0}
      minor: {type: Number, 'default': 0}
      isLatestMajor: {type: Boolean, 'default': true}
      isLatestMinor: {type: Boolean, 'default': true}
    # FIXIT: should it be mongoose.Schema.Types.ObjectId instead?
    original: {type: mongoose.Schema.ObjectId, ref: @modelName}
    parent: {type: mongoose.Schema.ObjectId, ref: @modelName}
    creator: {type: mongoose.Schema.ObjectId, ref: 'User'}
    created: {type: Date, 'default': Date.now}
    commitMessage: {type: String}
  )

  # Prevent multiple documents with the same version
  # Also used for looking up latest version, or specific versions.
  schema.index({'original': 1, 'version.major': -1, 'version.minor': -1}, {unique: true, name: 'version index'})

module.exports.SearchablePlugin = (schema, options) ->
  # this plugin must be added only after the others (specifically Versioned and Permissions)
  # have been added, as how it builds the text search index depends on which of those are used.

  searchable = options.searchable
  unless searchable
    throw Error('SearchablePlugin options must include list of searchable properties.')

  index = {}
  schema.uses_coco_search = true
  if schema.uses_coco_versions or schema.uses_coco_permissions
    index['index'] = 1
    schema.add(index: mongoose.Schema.Types.Mixed)

  index[prop] = 'text' for prop in searchable

  # should now have something like {'index': 1, name: 'text', body: 'text'}
  schema.plugin(textSearch)
  schema.index(index, { sparse: true, name: 'search index', language_override: 'searchLanguage' })

  schema.pre 'save', (next) ->
    console.log 'TD: SearchablePlugin save'
