c = require './../schemas'
ThangComponentSchema = require './thang_component'

SpecificArticleSchema = c.object()
c.extendNamedProperties SpecificArticleSchema  # name first
SpecificArticleSchema.properties.body = { type: 'string', title: 'Content', description: "The body content of the article, in Markdown.", format: 'markdown' }
SpecificArticleSchema.properties.i18n = {type: "object", format: 'i18n', props: ['name', 'body'], description: "Help translate this article"}
SpecificArticleSchema.displayProperty = 'name'

side = {title: "Side", description: "A side.", type: 'string', 'enum': ['left', 'right', 'top', 'bottom']}
thang = {title: "Thang", description: "The name of a Thang.", type: 'string', maxLength: 30, format:'thang'}

eventPrereqValueTypes = ["boolean", "integer", "number", "null", "string"] # not "object" or "array"
EventPrereqSchema = c.object {title: "Event Prerequisite", format: 'event-prereq', description: "Script requires that the value of some property on the event triggering it to meet some prerequisite.", "default": {eventProps: []}, required: ["eventProps"]},
  eventProps: c.array {'default': ["thang"], format:'event-value-chain', maxItems: 10, title: "Event Property", description: 'A chain of keys in the event, like "thang.pos.x" to access event.thang.pos.x.'}, c.shortString(title: "Property", description: "A key in the event property key chain.")
  equalTo: c.object {type: eventPrereqValueTypes, title: "==", description: "Script requires the event's property chain value to be equal to this value."}
  notEqualTo: c.object {type: eventPrereqValueTypes, title: "!=", description: "Script requires the event's property chain value to *not* be equal to this value."}
  greaterThan: {type: 'number', title: ">", description: "Script requires the event's property chain value to be greater than this value."}
  greaterThanOrEqualTo: {type: 'number', title: ">=", description: "Script requires the event's property chain value to be greater or equal to this value."}
  lessThan: {type: 'number', title: "<", description: "Script requires the event's property chain value to be less than this value."}
  lessThanOrEqualTo: {type: 'number', title: "<=", description: "Script requires the event's property chain value to be less than or equal to this value."}
  containingString: c.shortString(title: "Contains", description: "Script requires the event's property chain value to be a string containing this string.")
  notContainingString: c.shortString(title: "Does not contain", description: "Script requires the event's property chain value to *not* be a string containing this string.")
  containingRegexp: c.shortString(title: "Contains Regexp", description: "Script requires the event's property chain value to be a string containing this regular expression.")
  notContainingRegexp: c.shortString(title: "Does not contain regexp", description: "Script requires the event's property chain value to *not* be a string containing this regular expression.")

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

ResponseSchema = c.object {title: 'Dialogue Button', description: 'A button to be shown to the user with the dialogue.', required: ['text']},
  text: {title: 'Title', description: 'The text that will be on the button', 'default': 'Okay', type: 'string', maxLength: 30}
  channel: c.shortString(title: 'Channel', format: 'event-channel', description: 'Channel that this event will be broadcast over, like "level-set-playing".')
  event: {type: 'object', title: 'Event', description: 'Event that will be broadcast when this button is pressed, like {playing: true}.'}
  buttonClass: c.shortString(title: 'Button Class', description: 'CSS class that will be added to the button, like "btn-primary".')
  i18n: {type: 'object', format: 'i18n', props: ['text'], description: 'Help translate this button'}

PointSchema = c.object {title: 'Point', description: 'An {x, y} coordinate point.', format: 'point2d', required: ['x', 'y']},
  x: {title: 'x', description: 'The x coordinate.', type: 'number', 'default': 15}
  y: {title: 'y', description: 'The y coordinate.', type: 'number', 'default': 20}

SpriteCommandSchema = c.object {title: 'Thang Command', description: 'Make a target Thang move or say something, or select/deselect it.', required: ['id'], default: {id: 'Captain Anya'}},
  id: thang
  select: {title: 'Select', description: 'Select or deselect this Thang.', type: 'boolean'}
  say: c.object {title: 'Say', description: 'Make this Thang say a message.', required: ['text']},
    blurb: c.shortString(title: 'Blurb', description: "A very short message to display above this Thang's head. Plain text.", maxLength: 50)
    mood: c.shortString(title: 'Mood', description: 'The mood with which the Thang speaks.', 'enum': ['explain', 'debrief', 'congrats', 'attack', 'joke', 'tip', 'alarm'], 'default': 'explain')
    text: {title: 'Text', description: 'A short message to display in the dialogue area. Markdown okay.', type: 'string', maxLength: 400}
    sound: c.object {title: 'Sound', description: 'A dialogue sound file to accompany the message.', required: ['mp3', 'ogg']},
      mp3: c.shortString(title: 'MP3', format: 'sound-file')
      ogg: c.shortString(title: 'OGG', format: 'sound-file')
      preload: {title: 'Preload', description: 'Whether to load this sound file before the level can begin (typically for the first dialogue of a level).', type: 'boolean', 'default': false}
    responses: c.array {title: 'Buttons', description: 'An array of buttons to include with the dialogue, with which the user can respond.'}, ResponseSchema
    i18n: {type: 'object', format: 'i18n', props: ['blurb', 'text'], description: 'Help translate this message'}
  move: c.object {title: 'Move', description: 'Tell the Thang to move.', required: ['target'], default: {target: {x: 20, y: 20}, duration: 500}},
    target: _.extend _.cloneDeep(PointSchema), {title: 'Target', description: 'Target point to which the Thang will move.'}
    duration: {title: 'Duration', description: 'Number of milliseconds over which to move, or 0 for an instant move.', type: 'integer', minimum: 0, default: 500, format: 'milliseconds'}

NoteGroupSchema = c.object {title: 'Note Group', description: 'A group of notes that should be sent out as a result of this script triggering.', displayProperty: 'name'},
  name: {title: 'Name', description: 'Short name describing the script, like \"Anya greets the player\", for your convenience.', type: 'string'}
  dom: c.object {title: 'DOM', description: 'Manipulate things in the play area DOM, outside of the level area canvas.'},
    focus: c.shortString(title: 'Focus', description: 'Set the window focus to this DOM selector string.')
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
    lock: {title: 'Lock', description: "Whether the interface should be locked so that the player's focus is on the script, or specific areas to lock.", type: ['boolean', 'array'], items: {type: 'string', enum: ['surface', 'editor', 'palette', 'hud', 'playback', 'playback-hover', 'level']}}
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

  script: c.object {title: 'Script', description: 'Extra configuration for this action group.'},
    duration: {type: 'integer', minimum: 0, title: 'Duration', description: 'How long this script should last in milliseconds. 0 for indefinite.', format: 'milliseconds'}
    skippable: {type: 'boolean', title: 'Skippable', description: "Whether this script shouldn't bother firing when the player skips past all current scripts."}
    beforeLoad: {type: 'boolean', title: 'Before Load', description: 'Whether this script should fire before the level is finished loading.'}

  sprites: c.array {title: 'Sprites', description: 'Commands to issue to Sprites on the Surface.'}, SpriteCommandSchema

  surface: c.object {title: 'Surface', description: 'Commands to issue to the Surface itself.'},
    focus: c.object {title: 'Camera', description: 'Focus the camera on a specific point on the Surface.', format: 'viewport'},
      target: {anyOf: [PointSchema, thang, {type: null}], title: 'Target', description: 'Where to center the camera view.'}
      zoom: {type: 'number', minimum: 0, exclusiveMinimum: true, maximum: 64, title: 'Zoom', description: 'What zoom level to use.'}
      duration: {type: 'number', minimum: 0, title: 'Duration', description: 'in ms'}
      bounds: c.array {title: 'Boundary', maxItems: 2, minItems: 2, default: [{x: 0, y: 0}, {x: 46, y: 39}], format: 'bounds'}, PointSchema
      isNewDefault: {type: 'boolean', format: 'hidden', title: 'New Default', description: 'Set this as new default zoom once scripts end.'} # deprecated
    highlight: c.object {title: 'Highlight', description: 'Highlight specific Sprites on the Surface.'},
      targets: c.array {title: 'Targets', description: 'Thang IDs of target Sprites to highlight.'}, thang
      delay: {type: 'integer', minimum: 0, title: 'Delay', description: 'Delay in milliseconds before the highlight appears.'}
    lockSelect: {type: 'boolean', title: 'Lock Select', description: "Whether to lock Sprite selection so that the player can't select/deselect anything."}

  sound: c.object {title: 'Sound', description: 'Commands to control sound playback.'},
    suppressSelectionSounds: {type: 'boolean', title: 'Suppress Selection Sounds', description: 'Whether to suppress selection sounds made from clicking on Thangs.'}
    music: c.object { title: 'Music', description: 'Control music playing'},
      play: { title: 'Play', type: 'boolean'}
      file: c.shortString(title: 'File', enum: ['/music/music_level_1','/music/music_level_2','/music/music_level_3','/music/music_level_4','/music/music_level_5'])

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

LevelThangSchema = c.object {
  title: 'Thang'
  description: 'Thangs are any units, doodads, or abstract things that you use to build the level. (\"Thing\" was too confusing to say.)'
  format: 'thang'
  required: ['id', 'thangType', 'components']
  'default':
    id: 'Boris'
    thangType: 'Soldier'
    components: []
},
  id: thang # TODO: figure out if we can make this unique and how to set dynamic defaults
  # TODO: split thangType into 'original' and 'majorVersion' like the rest for consistency
  thangType: c.objectId(links: [{rel: 'db', href: '/db/thang_type/{($)}/version'}], title: 'Thang Type', description: 'A reference to the original Thang template being configured.', format: 'thang-type')
  components: c.array {title: 'Components', description: 'Thangs are configured by changing the Components attached to them.', uniqueItems: true, format: 'thang-components-array'}, ThangComponentSchema # TODO: uniqueness should be based on 'original', not whole thing

LevelSystemSchema = c.object {
  title: 'System'
  description: 'Configuration for a System that this Level uses.'
  format: 'level-system'
  required: ['original', 'majorVersion']
  'default':
    majorVersion: 0
    config: {}
  links: [{rel: 'db', href: '/db/level.system/{(original)}/version/{(majorVersion)}'}]
},
  original: c.objectId(title: 'Original', description: 'A reference to the original System being configured.', format: 'hidden')
  config: c.object {title: 'Configuration', description: 'System-specific configuration properties.', additionalProperties: true, format: 'level-system-configuration'}
  majorVersion: {title: 'Major Version', description: 'Which major version of the System is being used.', type: 'integer', minimum: 0, default: 0, format: 'hidden'}

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
  nextLevel: c.objectId(links: [{rel: 'extra', href: '/db/level/{($)}'}, {rel: 'db', href: '/db/level/{(original)}/version/{(majorVersion)}'}], format: 'latest-version-reference', title: 'Next Level', description: 'Reference to the next level players will play after beating this one.')
  scripts: c.array {title: 'Scripts', description: 'An array of scripts that trigger based on what the player does and affect things outside of the core level simulation.', 'default': []}, ScriptSchema
  thangs: c.array {title: 'Thangs', description: 'An array of Thangs that make up the level.', 'default': []}, LevelThangSchema
  systems: c.array {title: 'Systems', description: 'Levels are configured by changing the Systems attached to them.', uniqueItems: true, default: []}, LevelSystemSchema # TODO: uniqueness should be based on 'original', not whole thing
  victory: c.object {title: 'Victory Screen', default: {}, properties: {'body': {type: 'string', format: 'markdown', title: 'Body Text', description: 'Inserted into the Victory Modal once this level is complete. Tell the player they did a good job and what they accomplished!'}, i18n: {type: 'object', format: 'i18n', props: ['body'], description: 'Help translate this victory message'}}}
  i18n: {type: 'object', format: 'i18n', props: ['name', 'description'], description: 'Help translate this level'}
  icon: {type: 'string', format: 'image-file', title: 'Icon'}

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
