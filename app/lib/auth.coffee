User = require 'models/User'
{saveObjectToStorage, loadObjectFromStorage} = require 'lib/storage'

module.exports.CURRENT_USER_KEY = CURRENT_USER_KEY = 'whoami'
BEEN_HERE_BEFORE_KEY = 'beenHereBefore'

init = ->
  # load the user from local storage, and refresh it from the server.
  # If the server info doesn't match the local storage, refresh the page.
  # Also refresh and cache the gravatar info.
  loadedUser = loadObjectFromStorage(CURRENT_USER_KEY)
  module.exports.me = window.me = if loadedUser then new User(loadedUser) else null
  console.log 'TODO: wizardColor1' if me and not me.get('wizardColor1') # me.set('wizardColor1', Math.random())
  console.log 'going to get auth whoami from client'

  $.get('/auth/whoami', (downloadedUser) ->
    console.log 'getting auth whoami from client'
    trackFirstArrival() # should happen after trackEvent has loaded, due to the callback
    console.log 'TODO'
  )

init()

trackFirstArrival = ->
  # will have to filter out users who log in with existing accounts separately
  # but can at least not track logouts as first arrival using local storage
  beenHereBefore = loadObjectFromStorage(BEEN_HERE_BEFORE_KEY)
  return if beenHereBefore
  window.tracker?.trackEvent 'First Arrived' if not me
  saveObjectToStorage(BEEN_HERE_BEFORE_KEY, true)
