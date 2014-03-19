init = ->
  # load the user from local storage, and refresh it from the server.
  # If the server info doesn't match the local storage, refresh the page.
  # Also refresh and cache the gravatar info.
  module.exports.me = window.me = null

init()
