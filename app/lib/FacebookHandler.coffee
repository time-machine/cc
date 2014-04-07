CocoClass = require 'lib/CocoClass'
{me, CURRENT_USER_KEY} = require 'lib/auth'

module.exports = FacebookHandler = class FacebookHandler extends CocoClass
  constructor: ->
    super()

  subscriptions:
    'facebook-logged-in': 'onFacebookLogin'
    'facebook-logged-out': 'onFacebookLogout'

  onFacebookLogin: (e) =>
    # user is logged in also when the page first loads, so check to see
    # if we really need to do the lookup
    return if not me
    console.warn 'TD: onFacebookLogin', e

  onFacebookLogout: (e) =>
    console.warn 'On facebook logout not implemented.'

  destroy: ->
    console.log 'TD: destroy'
