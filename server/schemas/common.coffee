# language imports
Language = require '../languages'

# schema helper methods

me = module.exports

combine = (base, ext) ->
  return base unless ext?
  return _.extend(base, ext)

# Common schema properties
me.object = (ext, props) -> combine {type: 'object', additionalProperties: false, properties: props or {}}, ext
me.array = (ext, items) -> combine {type: 'array', items: items or {}}, ext
me.shortString = (ext) -> combine {type: 'string', maxLength: 100}, ext
me.pct = (ext) -> combine {type: 'number', maximum: 1.0, minumum: 0.0}, ext
me.date = (ext) -> combine {type: 'string', format: 'date-time'}, ext
me.objectId = (ext) -> schema = combine {type: ['object', 'string']}, ext # should just be string (Mongo ID), but sometimes mongoose turns them into objects representing those, so we are lenient

# BASICS
basicProps = (linkFragment) ->
  _id: me.objectId(links: [{rel: 'self', href: "/db/#{linkFragment}/{($)}"}], format: 'hidden')
  __v: {title: 'Mongoose Version', format: 'hidden'}

me.extendBasicProperties = (schema, linkFragment) ->
  schema.properties = {} unless schema.properties?
  _.extend(schema.properties, basicProps(linkFragment))

# TRANSLATEABLE
me.getLanguageCodeArray = -> Language.languageCodes
