c = require './common'

SpecificArticleSchema = c.object()
c.extendNamedProperties SpecificArticleSchema # name first
SpecificArticleSchema.properties.body = { type: 'string', title: 'Content', description: 'The body content of the article, in Markdown.', format: 'markdown' }
SpecificArticleSchema.displayProperty = 'name'

side = {title: 'Side', description: 'A side.', type: 'string', 'enum': ['left', 'right', 'top', 'bottom']}
thang = {title: 'Thang', description: 'The name of a Thang.', type: 'string', maxLength: 30, format: 'thang'}

eventPrereqValueTypes = ['boolean', 'integer', 'number', 'null', 'string'] # not 'object' or 'array'
EventPrereqSchema = c.object {title: 'Event Prerequisite', format: 'event-prereq', description: 'Script requires that the value of some property on the event triggering it to meet some prerequisite.', 'default': {eventProps: []}, required: ['eventProps']},
  eventProps: c.array {'default': ['thang'], format: 'event-value-chain', maxItems: 10, title: 'Event Property', description: 'A chain of keys in the event, like "thang.pos.x" to access event.thang.pos.x.'}, c.shortString(title: 'Property', description: 'A key in the event property key chain.')
  equalTo: c.object {type: eventPrereqValueTypes, title: '==', description: "Script requires the event's property chain value to be equal to this value."}
  notEqualTo: c.object {type: eventPrereqValueTypes, title: '!=', description: "Script requires the event's property chain value to *not* be equal to this value."}
  greaterThan: c.object {type: 'number', title: '>', description: "Script requires the event's property chain value to be greater than to this value."}
  greaterThanOrEqualTo: {type: 'number', title: '>=', description: "Script requires the event's property chain value to be greater than or equal to this value."}
  lessThan: {type: 'number', title: '<', description: "Script requires the event's property chain value to be less than this value."}
  lessThanOrEqualTo: {type: 'number', title: '<=', description: "Script requires the event's property chain value to be less than or equal to this value."}
  containingString: c.shortString(title: 'Contains', description: "Script requires the event's property chain value to be a string containing this string.")
  notContainingString: c.shortString(title: 'Does not contains', description: "Script requires the event's property chain value to *not* be a string containing this string.")

GoalSchema = c.object {title: 'Goal', description: 'A goal that the player can accomplish.', required: ['name', 'id']},
  name: c.shortString(title: 'Name', description: 'Name of the goal that the player will see, like \"Defeat eighteen dragons\".')
  i18n: {type: 'object', format: 'i18n', props: ['name'], description: 'Help translate this goal'}
  id: c.shortString(title: 'ID', description: 'Unique identifier for this goal, like \"defeat-dragons\".') # unique somehow?
  worldEndsAfter: {title: 'World Ends After', description: 'When included, ends the world this many seconds after this goal succeeds or fails.', type: 'number', minimum: 0, exclusiveMinimum: true, maximum: 300, default: 3}
  howMany: {title: 'How Many', description: 'When included, require only this many of the listed goal targets instead of all of them.', type: 'integer', minimum: 1}
  hiddenGoal: {title: 'Hidden', description: "Hidden goals don't show up in the goals area for the player until they're failed. (Usually they're obvious, like 'don't die'.)", 'type': 'boolean', default: false}
  killThangs: c.array {title: 'Kill Thangs', description: 'A list of Thang IDs the player should kill, or team names.', uniqueItems: true, minItems: 1, 'default': ['orges']}, thang
  saveThangs: c.array {title: 'Save Thangs', description: 'A list of Thang IDs the player should save, or team names.', uniqueItems: true, minItems: 1, 'default': ['humans']}, thang
  getToLocations: c.object {title: 'Get To Locations', description: 'TODO: explain', required: ['who', 'targets']},
    who: c.array {title: 'Who', description: 'The Thangs who must get to the target locations.', minItems: 1}, thang
    targets: c.array {title: 'Targets', description: 'The target locations to which the Thangs must get.', minItems: 1}, thang
  keepFromLocations: c.object {title: 'Keep From Locations', description: 'TODO: explain', required: ['who', 'targets']},
    who: c.array {title: 'Who', description: 'The Thangs who must not get to the target locations.', minItems: 1}, thang
    targets: c.array {title: 'Targets', description: 'The target locations to which the Thangs must not get.', minItems: 1}, thang
  leaveOffSides: c.object {title: 'Leave Off Sides', description: 'Sides of the level to get some Thangs to leave across.', required: ['who', 'sides']},
    who: c.array {title: 'Who', description: 'The Thangs which must leave off the sides of the level.', minItems: 1}, thang
    sides: c.array {title: 'Sides', description: 'The side off which the Thang must leave.', minItems: 1}, side
  keepFromLeavingOffSides: c.object {title: 'Keep From Leaving Off Sides', description: 'Sides of the level to keep some Thangs from leaving across.', required: ['who', 'sides']},
    who: c.array {title: 'Who', description: 'The Thangs which must not leave off the sides of the level.', minItems: 1}, thang
    sides: side, {title: 'Sides', description: 'The sides off which the Thang must not leave.', minItems: 1}, side
  collectThangs: c.object {title: 'Collect', description: 'Thangs that other Thangs must collect.', required: ['who', 'targets']},
    who: c.array {title: 'Who', description: 'The Thangs which must collect the target items.', minItems: 1}, thang
    targets: c.array {title: 'Targets', description: 'The target items which the Thangs must collect.', minItems: 1}, thang
  keepFromCollectingThangs: c.object {title: 'Keep From Collecting', description: 'Thangs that the player must prevent other Thangs from collecting.', required: ['who', 'targets']},
    who: c.array {title: 'Who', description: 'The Thangs which must collect the target items.', minItems: 1}, thang
    targets: c.array {title: 'Targets', description: 'The target items which the Thangs must collect.', minItems: 1}, thang

PointSchema = c.object {title: 'Point', description: 'An {x, y} coordinate point.', format: 'point2d', required: ['x', 'y']},
  x: {title: 'x', description: 'The x coordinate.', type: 'number', 'default': 15}
  y: {title: 'y', description: 'The y coordinate.', type: 'number', 'default': 20}

NoteGroupSchema = c.object {title: 'Note Group', description: 'A group of notes that should be sent out as a result of this script triggering.', displayProperty: 'name'},
  name: {title: 'Name', description: 'Short name describing the script, like \"Anya greets the player\", for your convenience.', type: 'string'}
  dom: c.object {title: 'DOM', description: 'Manipulate things in the play area DOM, outside of the level area canvas.'},
    focus: c.shortString(title: 'Target', description: 'Target highlight element DOM selector string.')
    showVictory: {
      title: 'Show Victory'
      description: 'Show the done button and maybe also the victory modal.'
      enum: [true, 'Done Button', 'Done Button And Modal'] # deprecate true, same as 'done_button_and_modal'
    }
    highlight: c.object {title: 'Highlight', description: 'Highlight the target DOM selector string with a big arrow.'},
      target: c.shortString(title: 'Target', description: 'Target highlight element DOM selector string.')
      delay: {type: 'integer', minimum: 0, title: 'Delay', description: "Show the highlight after this many milliseconds. Doesn't affect the dim shade cutoout highlight method."}
      offset: _.extend _.cloneDeep(PointSchema), {title: 'Offset', description: 'Pointing arrow tip offset in pixels from the default target.', format: null}
      rotation: {type: 'number', minimum: 0, title: 'Rotation', description: 'Rotation of the pointing arrow, in radians. PI / 2 points left, PI points up, etc.'}
      sides: c.array {title: 'Sides', description: 'Which sides of the target element to point at.'}, {type: 'string', 'enum': ['left', 'right', 'top', 'bottom'], title: 'Side', description: 'A side of the target element to point at.'}
    lock: {title: 'Lock', description: "Whether the interface should be locked so that the player's focus is on the script, or specific areas to lock.", type: ['boolean', 'array'], items: {type: 'string', enum: ['surface', 'editor', 'palette', 'hud', 'playback', 'playback-back', 'level']}}
    letterbox: {type: 'boolean', title: 'Letterbox', description: 'Turn letterbox mode on or off. Disables surface and playback controls.'}

  goals: c.object {title: 'Goals', description: 'Add or remove goals for the player to complete in the level.'},
    add: c.array {title: 'Add', description: 'Add these goals.'}, GoalSchema
    remove: c.array {title: 'Remove', description: 'Remove these goals.'}, GoalSchema

  playback: c.object {title: 'Playback', description: 'Control the playback of the level.'},
    playing: {type: 'boolean', title: 'Set Playing', description: 'Set whether playback is playing or paused.'}
    scrub: c.object {title: 'Scrub', description: 'Scrub the level playback time to a certain point.', default: {offset: 2, duration: 1000, toRatio: 0.5}},
      offset: {type: 'integer', title: 'Offset', description: 'Number of frames by which to adjust the scrub target time.', default: 2}
      duration: {type: 'integer', title: 'Duration', description: 'Number of milliseconds over which to scrub time.', minimum: 0, format: 'milliseconds'}
      toRatio: {type: 'number', title: 'To Progress Ratio', description: 'Set playback time to a target playback progress ratio.', minimum: 0, maximum: 1}
      toTime: {type: 'number', title: 'To Time', description: 'Set playback time to a target playback point, in seconds.', minimum: 0}
      toGoal: c.shortString(title: 'To Goal', description: 'Set playback time to when this goal was achieved. (TODO: not implemented.)')

  script: {'TODO'}
  sprites: {'TODO'}
  surface: {'TODO'}
  sound: {'TODO'}

ScriptSchema = c.object {
  title: 'Script'
  description: 'A script fires off a chain of notes to interact with the game when a certain event triggers it.'
  required: ['channel']
  'default': {channel: 'world:won', noteChain: []}
},
  id: c.shortString(title: 'ID', description: 'A unique ID that other scripts can rely on in their Happens After prereqs, for sequencing.') # uniqueness?
  channel: c.shortString(title: 'Event', format: 'event-channel', description: 'Event channel this script might trigger for, like "world:won".')
  eventPrereqs: c.array {title: 'Event Checks', description: 'Logical checks on the event for this script to trigger.', format: 'event-prereqs'}, EventPrereqSchema
  repeats: {title: 'Repeats', description: 'Whether this script can trigger more than once during a level.', type: 'boolean', 'default': false}
  scriptPrereqs: c.array {title: 'Happens After', description: 'Scripts that need to fire first.'},
    c.shortString(title: 'ID', description: 'A unique ID of a script that must have triggered before the parent script can trigger.')
  noteChain: c.array {title: 'Actions', description: 'A list of things that happen when this script triggers.'}, NoteGroupSchema

GeneralArticleSchema = c.object {
  title: 'Article'
  description: 'Reference to a general documentation article.'
  required: ['original']
  format: 'latest-version-reference'
  'default':
    original: null
    majorVersion: 0
  links: [{rel: 'db', href: '/db/article/{(original)}/version/{(majorVersion)}'}]
},
  original: c.objectId(title: 'Original', description: 'A reference to the original Article.')
  majorVersion: {title: 'Major Version', description: 'Which major version of the Article is being used.', type: 'integer', minimum: 0}

LevelSchema = c.object {
  title: 'Level'
  description: 'A spectacular level which will delight and educate its stalwart players with the sorcery of coding.'
  required: ['name', 'description', 'scripts', 'thangs', 'documentation']
  'default':
    name: 'Ineffable Wizardry'
    description: 'This level is indescribably flarmy.'
    documentation: {specificArticles: [], generalArticles: []}
    scripts: []
    thangs: []
}
c.extendNamedProperties LevelSchema # let's have the name be the first property
_.extend LevelSchema.properties,
  description: {title: 'Description', description: 'A short explanation of what this level is about.', type: 'string', maxLength: 65536, 'default': 'This level is indescribably flarmy!', format: 'markdown'}
  documentation: c.object {title: 'Documentation', description: 'Documentation articles relating to this level.', required: ['specificArticles', 'generalArticles'], 'default': {specificArticles: [], generalArticles: []}},
    specificArticles: c.array {title: 'Specific Articles', description: 'Specific documentation articles that live only in this level.', uniqueItems: true, 'default': []}, SpecificArticleSchema
    generalArticles: c.array {title: 'General Articles', description: 'General documentation articles that can be linked from multiple levels.', uniqueItems: true, 'default': []}, GeneralArticleSchema
  background: c.objectId({format: 'hidden'})
  nextLevel: c.objectId(links: [{rel: 'extra', href: '/db/level/{($)}'}, {rel: 'db', href: '/db/level/{original}/version/{(majorVersion)}'}], format: 'latest-version-reference', title: 'Next Level', description: 'Reference to the next level players will play after beating this one.')
  scripts: c.array {title: 'Scripts', description: 'An array of scripts that trigger based on what the player does and affect things outside of the core level simulation.', 'default': []}, ScriptSchema
  thangs: {'TODO'}
  systems: {'TODO'}
  victory: {'TODO'}
  i18n: {'TODO'}
  icon: {'TODO'}

c.extendBasicProperties LevelSchema, 'level'
c.extendSearchableProperties LevelSchema
c.extendVersionedProperties LevelSchema, 'level'
c.extendPermissionsProperties LevelSchema, 'level'

module.exports = LevelSchema

# To test:
# 1: Copy the schema from http://localhost:3000/db/level/schema
# 2. Open up the Treema demo page http://localhost:9090/demo.html
# 3. tv4.addSchema(metaschema.id, metaschema)
# 4. S = <paste big schema here>
# 5. tv4.validateMultiple(S, metaschema) and look for errors
