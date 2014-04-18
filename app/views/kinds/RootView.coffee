# A root view is one that replaces everything else on the screen when it
# comes into being, as opposed to sub-views which get inserted into other views.

CocoView = require './CocoView'

{logoutUser, me} = require 'lib/auth'
locale = require 'locale/locale'

filterKeyboardEvents = (allowedEvents, func) -> console.log 'TD: filterKeyboardEvents'

module.exports = class RootView extends CocoView
  events:
    'click #logout-button': 'logoutAccount'
    'change .language-dropdown': 'showDiplomatSuggestionModal'

  shortcuts:
    'backspace, delete': 'preventBackspace'

  afterRender: ->
    super()
    @buildLanguages()

  logoutAccount: -> console.log 'TD: logoutAccount'

  showWizardSettingsModal: -> console.log 'TD: showWizardSettingsModal'

  showLoading: ($el) -> console.log 'TD: showLoading'

  afterInsert: ->
    # force the browser to scroll to the hash
    # also messes with the browser history, so perhaps come up with a better solution
    super()
    hash = location.hash
    location.hash = ''
    location.hash = hash

    # TODO: automate tabs to put in hashes and navigate to them here

  buildLanguages: ->
    $select = @$el.find('.language-dropdown').empty()
    preferred = me.lang()
    codes = _.keys(locale)
    genericCodes = _.filter codes, (code) ->
      _.find(codes, (code2) ->
        code2 isnt code and code2.split('-')[0] is code)
    for code, localeInfo of locale when not (code in genericCodes) or code is preferred
      $select.append(
        $("<option></option>").attr("value", code).text(localeInfo.nativeDescription))
    $select.val(preferred).fancySelect()

  showDiplomatSuggestionModal: -> console.log 'TD: showDiplomatSuggestionModal'
