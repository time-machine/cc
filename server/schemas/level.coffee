c = require './common'

SpecificArticleSchema = c.object()
c.extendNamedProperties SpecificArticleSchema # name first
SpecificArticleSchema.properties.body = { type: 'string', title: 'Content', description: 'The body content of the article, in Markdown.', format: 'markdown' }
SpecificArticleSchema.displayProperty = 'name'

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

NoteGroupSchema = c.object {title: 'Note Group', description: 'A group of notes that should be sent out as a result of this script triggering.', displayProperty: 'name'},
  name: {title: 'Name', description: 'Short name describing the script, like \"Anya greets the player\", for your convenience.', type: 'string'}
  dom: {'TODO'}
  goals: {'TODO'}
  playback: {'TODO'}
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
