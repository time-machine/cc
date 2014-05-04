module.exports.typedArraySupport = typedArraySupport = Float32Array? # Not in IE until IE 10; we'll fall back to normal arrays
#module.exports.typedArraySupport = typedArraySupport = false # imitate IE9 (and in God.coffee)

unless ArrayBufferView?
  console.log 'TD: ArrayBufferView'

module.exports.clone = clone = (obj, skipThangs=false) ->
  console.log 'TD: clone'
