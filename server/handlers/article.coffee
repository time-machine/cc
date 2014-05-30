winston = require('winston')
request = require('request')
Article = require('../models/Article')
Handler = require('./Handler')

ArticleHandler = class ArticleHandler extends Handler
  modelClass: Article
  editableProperties: ['body', 'name']

  hasAccess: (req) -> console.log 'TD: ArticleHandler hasAccess'

module.exports = new ArticleHandler()
