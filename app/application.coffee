FacebookHandler = require 'lib/FacebookHandler'
locale = require 'locale/locale'
{me} = require 'lib/auth'
Tracker = require 'lib/Tracker'

Application = initialize: ->
  Router = require('lib/Router')
  @tracker = new Tracker()
  new FacebookHandler()
  # $.i18n.init {
  #   # lng: me?.lang() ? 'en'
  #   fallbackLng: 'en'
  #   resStore: locale
  # }, (t) =>
  #   @router = new Router()
  #   @router.subscribe()
  #   Object.freeze this if typeof Object.freeze is 'function'
  #   @router = Router

module.exports = Application
window.application = Application
