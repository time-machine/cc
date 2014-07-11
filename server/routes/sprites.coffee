# for sprite page, which uses the age of the files to
# order the sprites and make the more recent ones
# show up at the top

module.exports.setup = (app) ->
  app.get('/server/sprite-info', (req, res) ->
    console.log 'TD: sprites setup'
  )
