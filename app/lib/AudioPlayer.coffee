CocoClass = require 'lib/CocoClass'
cache = {}
{me} = require 'lib/auth'

createjs.Sound.registerPlugins([createjs.WebAudioPlugin, createjs.FlashPlugin, createjs.HTMLAudioPlugin])

class Manifest
  constructor: -> @storage = {}

  addPrimarySound: (filename) -> console.log 'TD: addPrimarySound'
  addSecondarySound: (filename) -> console.log 'TD: addSecondarySound'
  getData: -> console.log 'TD: getData'

class Media
  constructor: (name) -> @name = name if name

  loaded: false
  data: null
  progress: 0.0
  error: null
  name: ''

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

  playInterfaceSound: (name) ->
    filename = "/file/interface/#{name}#{@ext}"
    if filename of cache and createjs.Sound.loadComplete filename
      console.log 'TD: playInterfaceSound loadComplete'
    else
      @preloadInterfaceSounds [name] unless filename of cache
      @soundsToPlayWhenLoaded[name] = true

  # TODO: load Interface sounds somehow, somewhere, somewhen

  preloadSoundReference: (sound) -> console.log 'TD: preloadSoundReference'

  preloadSound: (filename, name) ->
    return unless filename
    return if filename of cache
    name ?= filename
    # SoundJS flips out if you try to register the same file twice
    createjs.Sound.registerSound(filename, name, 1, true) # 1: 1 channel, true: should preload
    cache[filename] = new Media(name)

  onSoundLoaded: (e) => console.log 'TD: onSoundLoaded'

  onSoundLoadError: (e) => console.log 'TD: onSoundLoadError'

  getStatus: (src) -> console.log 'TD: getStatus'

module.exports = new AudioPlayer()
