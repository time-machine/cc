module.exports.typedArraySupport = typedArraySupport = Float32Array? # Not in IE until IE 10; we'll fall back to normal arrays
#module.exports.typedArraySupport = typedArraySupport = false # imitate IE9 (and in God.coffee)

unless ArrayBufferView?
  # https://code.google.com/p/chromium/issues/detail?id=60449
  if typedArraySupport
    # We have it, it's just not exposed
    someArray = new Uint8Array(0)
    if someArray.__proto__
      # Most browsers
      ArrayBufferView = someArray.__proto__.__proto__.constructor
    else
      # IE before 11
      ArrayBufferView = Object.getPrototypeOf(Object.getPrototypeOf(someArray)).constructor
  else
    # If we don't have typed arrays, we don't need an ArrayBufferView
    ArrayBufferView = null

module.exports.clone = clone = (obj, skipThangs=false) ->
  console.log 'TD: clone'
