class CocoModel extends Backbone.Model
  initialize: ->
    super()
    if not @constructor.className
      console.error "#{@} needs a className set."
    @markToRevert()
    console.log 'TODO'
    # TODO

  markToRevert: ->
    @_revertAttributes = _.clone @attributes

module.exports = CocoModel
