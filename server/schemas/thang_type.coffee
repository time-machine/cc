c = require './common'
ThangComponentSchema = require './thang_component'

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
  frameBounds: c.array { title: 'Frame Bounds' }, c.array { title: 'Bounds' }, { type: 'number' }
  shapes: c.array {},
    bn: { type: 'string', title: 'Block Name' }
    gn: { type: 'string', title: 'Global Name' }
    im : { type: 'boolean', title: 'Is Mask' }
    m: { type: 'string', title: 'Uses Mask' }
  containers: c.array {},
    bn: { type: 'string', title: 'Block Name' }
    gn: { type: 'string', title: 'Global Name' }
    t: c.array {}, { type: 'number' }
    o: { type: 'boolean', title: 'Starts Hidden (_off)' }
    al: { type: 'number', title: 'Alpha'}
  animations: c.array {},
    bn: { type: 'string', title: 'Block Name' }
    gn: { type: 'string', title: 'Global Name' }
    t: c.array {}, { type: 'number', title: 'Transform' }
    a: c.array { title: 'Arguments' }
  tweens: c.array {},
    c.array { title: 'Function Chain', }, # FIXIT: extra comma after title
      c.object { title: 'Function Call' },
        n: { type: 'string', title: 'Name' }
        a: c.array { title: 'Arguments' }
  graphics: c.array {},
    bn: { type: 'string', title: 'Block Name' }
    p: { type: 'string', title: 'Path' }

PositionsSchema = c.object { title: 'Positions', description: 'Customize position offsets.' },
  registration: c.point2d { title: 'Registration Point', description: 'Action-specific registration point override.' }
  torso: c.point2d { title: 'Torso Offset', description: 'Action-specific torso offset override.' }
  mouth: c.point2d { title: 'Mouth Offset', description: 'Action-specific mouth offset override.' }
  aboveHead: c.point2d { title: 'Above Head Offset', description: 'Action-specific above-head offset override.' }

# scale: { title: 'Scale', type: 'number' }
# flipX: { title: 'Flip X', type: 'boolean', description: 'Flip this animation horizontally?' }
# flipY: { title: 'Flip Y', type: 'boolean', description: 'Flip this animation vertically?' }

_.extend ThangTypeSchema.properties,
  raw: c.object {title: 'Raw Vector Data'},
    shapes: c.object {title: 'Shapes', additionalProperties: ShapeObjectSchema}
    containers: c.object {title: 'Containers', additionalProperties: ContainerObjectSchema}
    animations: c.object {title: 'Animations', additionalProperties: RawAnimationObjectSchema}

  actions: c.object { title: 'Actions', additionalProperties: { $ref: '#/definitions/action' } }
  soundTriggers: c.object { title: 'Sound Triggers', additionalProperties: c.array({}, { $ref: '#/definitions/sound' }) },
    say: c.object { format: 'slug-props', additionalProperties: { $ref: '#/definitions/sound' } },
      defaultSimlish: c.array({}, { $ref: '#/definitions/sound' })
      swearingSimlish: c.array({}, { $ref: '#/definitions/sound' })
  rotationType: { title: 'Rotation', type: 'string', enum: ['isometric', 'fixed'] }
  matchWorldDimensions: { title: 'Match World Dimensions', type: 'boolean' }
  shadow: { title: 'Shadow Diameter', type: 'number', format: 'meters', description: 'Shadow diameter in meters' }
  layerPriority: { title: 'Layer Priority', type: 'integer', description: 'Within its layer, sprites are sorted by layer priority, then y, then z.' }
  scale: { title: 'Scale', type: 'number' }
  positions: PositionsSchema
  snap: c.object { title: 'Snap', description: 'In the level editor, snap positioning to these intervals', required: ['x', 'y'] },
    x: { title: 'Snap X', type: 'number', description: 'Snap to this many meters in the x-direction.', default: 4 }
    y: { title: 'Snap Y', type: 'number', description: 'Snap to this many meters in the y-direction.', default: 4 }
  components: c.array {title: 'Components', description: 'Thangs are configured by changing the Components attached to them.', uniqueItems: true, format: 'thang-components-array'}, ThangComponentSchema # TODO: uniqueness should be based on 'original', not whole thing

# TODO

module.exports = ThangTypeSchema
