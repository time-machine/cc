# A root view is one that replaces everything else on the screen when it
# comes into being, as opposed to sub-views which get inserted into other views.

CocoView = require './CocoView'

module.exports = class RootView extends CocoView
  events:
    'click #logout-button': 'logoutAccount'
    'change .language-dropdown': 'showDiplomatSuggestionModal'

  shortcuts:
    'backspace, delete': 'preventBackspace'

  afterRender: ->
    super()
    @buildLanguages()

  logoutAccount: ->
    console.log 'TD: logoutAccount'

  buildLanguages: ->
    $select = @$el.find('.language-dropdown').empty()
    console.log 'TD: buildLanguages', $select

  showDiplomatSuggestionModal: ->
    console.log 'TD: showDiplomatSuggestionModal'
