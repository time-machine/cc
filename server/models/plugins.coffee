module.exports.NamedPlugin = (schema) ->
  schema.add({name: String, slug: String})
  schema.index({'slug': 1}, {unique: true, sparse: true, name: 'slug index'})

  schema.pre('save', (next) ->
    console.log 'TD: NamedPlugin save'
  )
