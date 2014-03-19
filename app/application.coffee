locale = require 'locale/locale'

Application = initialize: ->
  Router = require('lib/Router')
  $.i18n.init {
    lng: 'en'
    fallbackLng: 'en'
    resStore: locale
  }, (t) =>
    @router = new Router()
    @router.subscribe()
    Object.freeze this if typeof Object.freeze is 'function'
    @router = Router

module.exports = Application
window.application = Application
