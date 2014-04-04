# language imports
Language = require '../languages'

# schema helper methods

me = module.exports

combine = (base, ext) ->
  return base unless ext?
  return _.extend(base, ext)

# Common schema properties
me.object = (ext, props) -> combine {type: 'object', additionalProperties: false, properties: props or {}}, ext
me.shortString = (ext) -> combine {type: 'string', maxLength: 100}, ext
