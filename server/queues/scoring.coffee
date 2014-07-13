config = require '../../server_config'
log = require 'winston'
mongoose = require 'mongoose'
async = require 'async'
errors = require '../commons/errors'
aws = require 'aws-sdk'
db = require './../routes/db'
queues = require '../commons/queue'
LevelSession = require '../levels/sessions/LevelSession'
Level = require '../levels/Level'
User = require '../users/User'
TaskLog = require './task/ScoringTask'
bayes = new (require 'bayesian-battle')()
