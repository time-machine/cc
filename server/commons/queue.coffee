config = require '../../server_config'
log = require 'winston'
mongoose = require 'mongoose'
async = require 'async'
aws = require 'aws-sdk'
db = require './database'
mongoose = require 'mongoose'
events = require 'events'
crypto = require 'crypto'

module.exports.queueClient = undefined

defaultMessageVisibilityTimeoutInSeconds = 500
defaultMessageReceiptTimeout = 10

module.exports.initializeQueueClient = (cb) ->
  console.log 'TD: initializeQueueClient'

generateQueueClient = ->
  console.log 'TD: generateQueueClient'

class SQSQueueClient
  registerQueue: (queueName, options, callback) ->
    console.log 'TD: registerQueue'

  constructor: ->
    console.log 'TD: constructor'

  _configure: ->
    console.log 'TD: _configure'

  _generateSQSInstance: -> new aws.SQS()

  _logAndThrowFatalException: (errorMessage) ->
    console.log 'TD: _logAndThrowFatalException'

class SQSQueue extends events.EventEmitter
  constructor: (@queueName, @queueUrl, @sqs) ->

  subscribe: (eventName, callback) -> @on eventName, callback
  unsubscribe: (eventName, callback) -> @removeListener eventName, callback

  receiveMessage: (callback) ->
    console.log 'TD: receiveMessage'

  deleteMessage: (receiptHandle, callback) ->
    console.log 'TD: deleteMessage'

  changeMessageVisibilityTimeout: (secondsFromNow, receiptHandle, callback) ->
    console.log 'TD: changeMessageVisibilityTimeout'

  sendMessage: (messageBody, delaySeconds, callback) ->
    console.log 'TD: sendMessage'

  listenForever: => console.log 'TD: listenForever'
