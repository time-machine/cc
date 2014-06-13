#language imports
Language = require './languages'
# schema helper methods

me = module.exports

combine = (base, ext) ->
  return base unless ext?
  return _.extend(base, ext)

urlPattern = '^(ht|f)tp(s?)\:\/\/[0-9a-zA-Z]([-.\w]*[0-9a-zA-Z])*(:(0-9)*)*(\/?)([a-zA-Z0-9\-\.\?\,\'\/\\\+&%\$#_=]*)?$'

# Common schema properties
me.object = (ext, props) -> combine {type: 'object', additionalProperties: false, properties: props or {}}, ext
me.array = (ext, items) -> combine {type: 'array', items: items or {}}, ext
me.shortString = (ext) -> combine {type: 'string', maxLength: 100}, ext
me.pct = (ext) -> combine {type: 'number', maximum: 1.0, minimum: 0.0}, ext
me.date = (ext) -> combine {type: 'string', format: 'date-time'}, ext
me.objectId = (ext) -> schema = combine {type: ['object', 'string']}, ext # should just be string (Mongo ID), but sometimes mongoose turns them into objects representing those, so we are lenient

PointSchema = me.object {title: 'Point', description: 'An {x, y} coordinate point.', format: 'point2d', required: ['x', 'y']},
  x: {title: 'x', description: 'The x coordinate.', type: 'number', 'default': 15}
  y: {title: 'y', description: 'The y coordinate.', type: 'number', 'default': 20}

me.point2d = (ext) -> combine(_.cloneDeep(PointSchema), ext)

SoundSchema = me.object { format: 'sound' },
  mp3: { type: 'string', format: 'sound-file' }
  ogg: { type: 'string', format: 'sound-file' }

me.sound = (props) ->
  obj = _.cloneDeep(SoundSchema)
  for prop of props
    obj.properties[prop] = props[prop]
  obj

# BASICS
basicProps = (linkFragment) ->
  _id: me.objectId(links: [{rel: 'self', href: "/db/#{linkFragment}/{($)}"}], format: 'hidden')
  __v: {title: 'Mongoose Version', format: 'hidden'}

me.extendBasicProperties = (schema, linkFragment) ->
  schema.properties = {} unless schema.properties?
  _.extend(schema.properties, basicProps(linkFragment))

# NAMED

namedProps = ->
  name: me.shortString({title: 'Name'})
  slug: me.shortString({title: 'Slug', format: 'hidden'})

me.extendNamedProperties = (schema) ->
  schema.properties = {} unless schema.properties?
  _.extend(schema.properties, namedProps())

# VERSIONED

versionedProps = (linkFragment) ->
  version:
    'default': { minor: 0, major: 0, isLatestMajor: true, isLatestMinor: true }
    format: 'version'
    title: 'Version'
    type: 'object'
    readOnly: true
    additionalProperties: false
    properties:
      major: { type: 'number', minimum: 0 }
      minor: { type: 'number', minimum: 0 }
      isLatestMajor: { type: 'boolean' }
      isLatestMinor: { type: 'boolean' }
  original: me.objectId(links: [{rel: 'extra', href: "/db/#{linkFragment}/{($)}"}], format: 'hidden') # TODO: figure out useful 'rel' values here
  parent: me.objectId(links: [{rel: 'extra', href: "/db/#{linkFragment}/{($)}"}], format: 'hidden')
  creator: me.objectId(links: [{rel: 'extra', href: "/db/user/{($)}"}], format: 'hidden')
  created: me.date({ title: 'Created', readOnly: true })
  commitMessage: { type: 'string', maxLength: 500, title: 'Commit Message', readOnly: true }

me.extendVersionedProperties = (schema, linkFragment) ->
  schema.properties = {} unless schema.properties?
  _.extend(schema.properties, versionedProps(linkFragment))

# SEARCHABLE

searchableProps = ->
  index: { format: 'hidden' }

me.extendSearchableProperties = (schema) ->
  schema.properties = {} unless schema.properties?
  _.extend(schema.properties, searchableProps())

# PERMISSIONED

permissionsProps = ->
  permissions:
    type: 'array'
    items:
      type: 'object'
      additionalProperties: false
      properties:
        target: {}
        access: {type: 'string', 'enum': ['read', 'write', 'owner']}
    format: 'hidden'

me.extendPermissionsProperties = (schema) ->
  schema.properties = {} unless schema.properties?
  _.extend(schema.properties, permissionsProps())

# TRANSLATABLE

me.generateLanguageCodeArrayRegex = -> console.log 'TD: generateLanguageCodeArrayRegex'

me.getLanguageCodeArray = ->
  return Language.languageCodes

me.getLanguageObject = -> console.log 'TD: getLanguageObject'
