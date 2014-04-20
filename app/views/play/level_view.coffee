View = require 'views/kinds/RootView'
template = require 'templates/play/level'
{me} = require 'lib/auth'

module.exports = class PlayLevelView extends View
  id: 'level-view'
  template: template
  cache: false
  shortcutsEnabled: true
  startsLoading: true
  isEditorPreview: false
