CocoClass = require 'lib/CocoClass'
cache = {}
{me} = require 'lib/auth'

createjs.Sound.registerPlugins([createjs.WebAudioPlugin, createjs.FlashPlugin, createjs.HTMLAudioPlugin])

class AudioPlayer extends CocoClass
  subscriptions:
    'play-sound': (e) -> console.log 'TD: play-sound'

  constructor: () ->
    super()
    console.log 'TD: constructor'

  # PUBLIC LOADING METHODS

  soundForDialogue: (message, soundTriggers) -> console.log 'TD: soundForDialogue'

  preloadInterfaceSounds: (names) -> console.log 'TD: preloadInterfaceSounds', names

  # TODO: load Interface sounds somehow, somewhere, somewhen

  preloadSoundReference: (sound) -> console.log 'TD: preloadSoundReference'

  onSoundLoadError: (e) => console.log 'TD: onSoundLoadError'

  getStatus: (src) -> console.log 'TD: getStatus'

module.exports = new AudioPlayer()
