CocoClass = require 'lib/CocoClass'
cache = {}
{me} = require 'lib/auth'

createjs.Sound.registerPlugins([createjs.WebAudioPlugin, createjs.FlashPlugin, createjs.HTMLAudioPlugin])

class Manifest
  constructor: -> @storage = {}

  addPrimarySound: (filename) -> console.log 'TD: addPrimarySound'
  addSecondarySound: (filename) -> console.log 'TD: addSecondarySound'
  getData: -> console.log 'TD: getData'

class AudioPlayer extends CocoClass
  subscriptions:
    'play-sound': (e) -> console.log 'TD: play-sound'

  constructor: () ->
    super()
    @ext = if createjs.Sound.getCapability('mp3') then '.mp3' else '.ogg'
    @listenToSound()
    @createNewManifest()
    @soundsToPlayWhenLoaded = {}

  createNewManifest: ->
    @manifest = new Manifest()

  listenToSound: ->
    # I would like to go through PreloadJS to organize loading by queue, but
    # when I try to set it up, I get an error with the Sound plugin.
    # So for now, we'll just load through SoundJS instead.
    createjs.Sound.on 'fileload', @onSoundLoaded

  # PUBLIC LOADING METHODS

  soundForDialogue: (message, soundTriggers) -> console.log 'TD: soundForDialogue'

  preloadInterfaceSounds: (names) ->
    for name in names
      filename = "/file/interface/#{name}#{@ext}"
      @preloadSound filename, name

  # TODO: load Interface sounds somehow, somewhere, somewhen

  preloadSoundReference: (sound) -> console.log 'TD: preloadSoundReference'

  preloadSound: (filename, name) -> console.log 'TD: preloadSound', filename, name

  onSoundLoaded: (e) => console.log 'TD: onSoundLoaded'

  onSoundLoadError: (e) => console.log 'TD: onSoundLoadError'

  getStatus: (src) -> console.log 'TD: getStatus'

module.exports = new AudioPlayer()
