# for sprite page, which uses thew age of the files to order the sprites and
# make the more recent ones show up at the top

module.exports.setupRoutes = (app) ->
  app.get('/server/sprite-info', (req, res) ->
    console.log 'TD: sprites setupRoutes'
  )
