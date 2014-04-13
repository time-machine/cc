c = require './common'

ThangTypeSchema = c.object()
c.extendNamedProperties ThangTypeSchema # name first

ShapeObjectSchema = c.object { title: 'Shape' },
  fc: { type: 'string', title: 'Fill Color' }
  lf: { type: 'array', title: 'Linear Gradient Fill' }
  ls: { type: 'array', title: 'Linear Gradient Stroke' }
  p: { type: 'string', title: 'Path' }
  de: { type: 'array', title: 'Draw Ellipse'}
  # TODO

_.extend ThangTypeSchema.properties,
  raw: c.object {title: 'Raw vector Data'},
    shape: c.object {title: 'Shapes', additionalProperties: ShapeObjectSchema}

module.exports = ThangTypeSchema
