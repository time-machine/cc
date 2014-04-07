GRAVATAR_URL = 'https://www.gravatar.com/'
CocoModel = require './CocoModel'

module.exports = class User extends CocoModel
  # class prop, accessable with Class.X (User.className) or @constructor.X (@constructor.className)
  # @constructor is equal with this class (User)
  @className: 'User'

  # prototype prop, accessable after class is constructed / newed
  # also accessable within class with `@` (@urlRoot)
  urlRoot: '/db/user'

  initialize: ->
    super()
    @on 'change:emailHash', ->
      console.log 'TD: change:emailHash'

  loadGravatarProfile: ->
    emailHash = @get('emailHash')
    return if not emailHash
    functionName = 'gotProfile' + emailHash
    profileUrl = "#{GRAVATAR_URL}#{emailHash}.json?callback=#{functionName}"
    script = $("<script src=#{profileUrl} type='text/javascript'></script>")
    $('head').append(script)
    $('body').on('load', (e) -> console.log 'we dit it!', e)
    window[functionName] = (profile) =>
      console.log 'TD: loadGravatarProfile', profile

    func = => @gravatarProfile = null unless @gravatarProfile

    # need to set longer timeout so that `callback` is run 1st before `func`
    setTimeout(func, 1000)

  lang: ->
    @get('preferredLanguage') or 'en-US'
