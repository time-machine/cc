c = require './common'

ThangTypeSchema = c.object()
c.extendNamedProperties ThangTypeSchema # name first

ShapeObjectSchema = c.object { title: 'Shape' },
  fc: { type: 'string', title: 'Fill Color' }
  lf: { type: 'array', title: 'Linear Gradient Fill' }
  ls: { type: 'array', title: 'Linear Gradient Stroke' }
  p: { type: 'string', title: 'Path' }
  de: { type: 'array', title: 'Draw Ellipse' }
  sc: { type: 'string', title: 'Stroke Color' }
  ss: { type: 'array', title: 'Stroke Style' }
  t: c.array {}, { type: 'number', title: 'Transform' }
  m: { type: 'string', title: 'Mask' }

ContainerObjectSchema = c.object { format: 'container' },
  b: c.array { title: 'Bounds' }, { type: 'number' }
  c: c.array { title: 'Children' }, { anyOf: [
    { type: 'string', title: 'Shape Child' },
    c.object { title: 'Container Child' }
      gn: { type: 'string', title: 'Global Name' }
      t: c.array {}, { type: 'number' }
  ]}

RawAnimationObjectSchema = c.object {},
  bounds: c.array { title: 'Bounds' }, { type: 'number' }
  # TODO

_.extend ThangTypeSchema.properties,
  raw: c.object {title: 'Raw vector Data'},
    shape: c.object {title: 'Shapes', additionalProperties: ShapeObjectSchema}
    containers: c.object {title: 'Containers', additionalProperties: ContainerObjectSchema}
    animations: c.object {title: 'Animations', additionalProperties: RawAnimationObjectSchema}

  # TODO

module.exports = ThangTypeSchema
