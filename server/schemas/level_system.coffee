c = require './common'
metaschema = require './metaschema'

jitterSystemCode = """
class Jitter extends System
  constructor: (world, config) ->
    super world, config
    @idlers = @addRegistry (thang) -> thang.exists and thang.acts and thang.moves and thang.action is 'idle'

  update: ->
    # We return a simple numeric hash that will combine to a frame hash
    # help us determine whether this frame has changed in resimulations.
    hash = 0
    for thang in @idlers
      hash += thang.pos.x += 0.5 - Math.random()
      hash += thang.pos.y += 0.5 - Math.random()
      thang.hasMoved = true
    return hash
"""

PropertyDocumentationSchema = c.object {
  title: "Property Documentation"
  description: "Documentation entry for a property this System will add to its Thang which other Systems might want to also use."
  "default":
    name: "foo"
    type: "object"
    description: "This System provides a 'foo' property to satisfy all one's foobar needs. Use it wisely."
  required: ['name', 'type', 'description']
},
  name: {type: 'string', pattern: c.identifierPattern, title: "Name", description: "Name of the property."}
  type: c.shortString(title: "Type", description: "Intended type of the property.")  # not actual JS types, just whatever they describe...
  description: {type: 'string', description: "Description of the property.", maxLength: 1000}
  args: c.array {title: "Arguments", description: "If this property has type 'function', then provide documentation for any function arguments."}, c.FunctionArgumentSchema

LevelSystemSchema = c.object {
  # TODO
}

module.exports = LevelSystemSchema
