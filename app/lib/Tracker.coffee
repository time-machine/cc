{me} = require 'lib/auth'

module.exports = class Tracker
  constructor: ->
    if window.tracker
      console.error 'Overwrote our Tracker!', window.tracker
    window.tracker = @
    @isProduction = document.location.href.search('codecombat.com') isnt -1
    @identify()
    @updateOlark()

  identify: (traits) ->
    return unless me and @isProduction and analytics?
    console.log 'TD: identify'

  updateOlark: ->
    return unless me and olark?
    console.log 'TD: updateOlark'

  trackEvent: (event, properties, includeProviders=null) =>
    return unless me and @isProduction and analytics?
    console.log 'TD: trackEvent'
