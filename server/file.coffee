module.exports.setupRoutes = (app) ->
  app.all '/file*', (req, res) ->
    console.log 'TD: file setupRoutes'
