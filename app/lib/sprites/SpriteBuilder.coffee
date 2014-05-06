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
      container.setTransform(localContainer.t...)
      console.log 'TD: buildMovieClipContainers o' if localContainer.o?
      console.log 'TD: buildMovieClipContainers al' if localContainer.al?
      map[localContainer.bn] = container
    map

  buildShapeFromStore: (shapeKey, debug=false) ->
    shapeData = @shapeStore[shapeKey]
    shape = new createjs.Shape()
    if shapeData.lf?
      console.log 'TD: buildShapeFromStore lf'
    else if shapeData.fc?
      shape.graphics.f shapeData.fc
    if shapeData.ls?
      console.log 'TD: buildShapeFromStore ls'
    else if shapeData.sc?
      shape.graphics.s shapeData.sc
    shape.graphics.ss shapeData.ss... if shapeData.ss?
    console.log 'TD: buildShapeFromStore de' if shapeData.de?
    shape.graphics.p shapeData.p if shapeData.p?
    shape.setTransform shapeData.t...
    shape

  buildContainerFromStore: (containerKey) ->
    console.error "Yo we don't have no", containerKey unless containerKey
    contData = @containerStore[containerKey]
    cont = new createjs.Container
    cont.initialize()
    for childData in contData.c
      if _.isString(childData)
        child = @buildShapeFromStore(childData)
      else
        console.log 'TD: buildContainerFromStore'
      cont.addChild(child)
    cont.bounds = new createjs.Rectangle(contData.b...)
    cont
