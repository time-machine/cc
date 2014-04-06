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
  me.set('wizardColor1', Math.random()) if me and not me.get('wizardColor1')
  $.get('/auth/whoami', (downloadedUser) ->
    trackFirstArrival() # should happen after trackEvent has loaded, due to the callback
    changedState = Boolean(downloadedUser) isnt Boolean(loadedUser)
    switchedUser = downloadedUser and loadedUser and downloadedUser._id isnt loadedUser._id

    if changedState or switchedUser
      saveObjectToStorage(CURRENT_USER_KEY, downloadedUser)
      window.location.reload()

    if me and not me.get('testGroupNumber')?
      # assign testGroupNumber to returning visitors; new ones in server/handlers/user
      console.log 'TD: testGroupNumber'
    saveObjectToStorage(CURRENT_USER_KEY, downloadedUser)
  )
  if module.exports.me
    module.exports.me.loadGravatarProfile()
    module.exports.me.on('sync', userSynced)

userSynced = (user) ->
  console.log 'TD: userSynced', user

init()

onSetVolume = (e) ->
  console.log 'TD: onSetVolume', e

Backbone.Mediator.subscribe('level-set-volume', onSetVolume, module.exports)

trackFirstArrival = ->
  # will have to filter out users who log in with existing accounts separately
  # but can at least not track logouts as first arrival using local storage
  beenHereBefore = loadObjectFromStorage(BEEN_HERE_BEFORE_KEY)
  return if beenHereBefore
  window.tracker?.trackEvent 'First Arrived' if not me
  saveObjectToStorage(BEEN_HERE_BEFORE_KEY, true)
