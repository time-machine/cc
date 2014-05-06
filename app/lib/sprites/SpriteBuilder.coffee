module.exports = class SpriteBuilder
  constructor: (@thangType, @options) ->
    raw = _.cloneDeep(@thangType.get('raw'))
    @shapeStore = raw.shapes
    @containerStore = raw.containers
    @animationStore = raw.animations

  setOptions: (@options) ->

  buildMovieClip: (animationName, movieClipArgs...) ->
    animData = @animationStore[animationName]
    console.log "couldn't find animData from", @animationStore, "for", animationName unless animData
    locals = {}
    _.extend locals, @buildMovieClipShapes(animData.shapes)
    _.extend locals, @buildMovieClipContainers(animData.containers)
    console.log 'TD: buildMovieClip'

  buildMovieClipShapes: (localShapes) ->
    map = {}
    for localShape in localShapes
      console.log 'TD: buildMovieClipShapes', localShape
    map

  buildMovieClipContainers: (localContainers) ->
    map = {}
    for localContainer in localContainers
      container = @buildContainerFromStore(localContainer.gn)
      console.log 'TD: buildMovieClipContainers'
    map

  buildContainerFromStore: (containerKey) ->
    console.error "Yo we don't have no", containerKey unless containerKey
    contData = @containerStore[containerKey]
    console.log 'TD: buildContainerFromStore', containerKey, @containerStore
