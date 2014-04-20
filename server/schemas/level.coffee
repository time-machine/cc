c = require './common'

SpecificArticleSchema = c.object()
c.extendNamedProperties SpecificArticleSchema # name first
SpecificArticleSchema.properties.body = { type: 'string', title: 'Content', description: 'The body content of the article, in Markdown.', format: 'markdown' }
SpecificArticleSchema.displayProperty = 'name'

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
  # TODO

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
