# A root view is one that replaces everything else on the screen when it
# comes into being, as opposed to sub-views which get inserted into other views.

CocoView = require './CocoView'

module.exports = class RootView extends CocoView
  events:
    'click #logout-button': 'logoutAccount'
    'change .language-dropdown': 'showDiplomatSuggestionModal'

  shortcuts:
    'backspace, delete': 'preventBackspace'

  logoutAccount: ->
    console.log 'TD: logoutAccount'

  showDiplomatSuggestionModal: ->
    console.log 'TD: showDiplomatSuggestionModal'
