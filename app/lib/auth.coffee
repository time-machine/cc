User = require 'models/User'
{loadObjectFromStorage} = require 'lib/storage'

module.exports.CURRENT_USER_KEY = CURRENT_USER_KEY = 'whoami'

init = ->
  # load the user from local storage, and refresh it from the server.
  # If the server info doesn't match the local storage, refresh the page.
  # Also refresh and cache the gravatar info.
  loadedUser = loadObjectFromStorage(CURRENT_USER_KEY)
  module.exports.me = window.me = if loadedUser then new User(loadedUser) else null

init()
