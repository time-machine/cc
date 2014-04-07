module.exports.setupRoutes = (app) ->
  app.all '/folder*', (req, res) ->
    console.log 'TD: folder setupRoutes'
