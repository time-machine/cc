log = require 'winston'
errors = require '../commons/errors'
scoringQueue = require '../queues/scoring'

module.exports.setup = (app) ->
  scoringQueue.setup()

  #app.post '/queue/scoring/pairwise', (req, res) ->
  #  handler = loadQueueHandler 'scoring'
  #  handler.addPairwiseTaskToQueue req, res

  app.get '/queue/messagesInQueueCount', (req, res) ->
    console.log 'TD: messagesInQueueCount'

  app.post '/queue/scoring/resimulateAllSessions', (req, res) ->
    console.log 'TD: resimulateAllSessions'

  app.post '/queue/scoring/getTwoGames', (req, res) ->
    console.log 'TD: getTwoGames'

  app.put '/queue/scoring/recordTwoGames', (req, res) ->
    console.log 'TD: recordTwoGames'

  app.all '/queue/*', (req, res) ->
    console.log 'TD: queue'

setResponseHeaderToJSONContentType = (res) -> res.setHeader('Content-Type', 'application/json')

getQueueNameFromPath = (path) ->
  console.log 'TD: getQueueNameFromPath'

loadQueueHandler = (queueName) -> require ('../queues/' + queueName)

isHTTPMethodGet = (req) -> return req.route.method is 'get'

isHTTPMethodPost = (req) -> return req.route.method is 'post'

isHTTPMethodPut = (req) -> return req.route.method is 'put'

sendMethodNotSupportedError = (req, res) -> errors.badMethod(res, ['GET', 'POST', 'PUT'], 'Queues do not support the HTTP method used.' )

sendQueueError = (req, res, error) -> errors.serverError(res, "Route #{req.path} had a problem: #{error}")
