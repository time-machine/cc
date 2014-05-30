# The JSON Schema Core/Validation Meta-Schema, but with titles and descriptions
# added to make it easier to edit in Treema, and in CoffeeScript

module.exports =
  id: "metaschema"
  displayProperty: "title"
  $schema: "http://json-schema.org/draft-04/schema#"
  title: "Schema"
  description: "Core schema meta-schema"
  definitions:
    schemaArray:
      type: "array"
      minItems: 1
      items: { $ref: "#" }
      title: "Array of Schemas"
      "default": [{}]
    positiveInteger:
      type: "integer"
      minimum: 0
      title: "Positive Integer"
    positiveIntegerDefault0:
      allOf: [ { $ref: "#/definitions/positiveInteger" }, { "default": 0 } ]
    simpleTypes:
      title: "Single Type"
      "enum": [ "array", "boolean", "integer", "null", "number", "object", "string" ]
    stringArray:
      type: "array"
      items: { type: "string" }
      minItems: 1
      uniqueItems: true
      title: "String Array"
      "default": ['']
  type: "object"
  properties:
    id:
      type: "string"
      format: "uri"
    $schema:
      type: "string"
      format: "uri"
      "default": "http://json-schema.org/draft-04/schema#"
    title:
      type: "string"
    description:
      type: "string"
    "default": {}
    # TODO
