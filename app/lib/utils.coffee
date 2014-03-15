module.exports.clone = (obj) ->
  return obj if obj is null or typeof (obj) isnt "object"
  temp = obj.constructor()
  for key of obj
    temp[key] = module.exports.clone(obj[key])
  temp

# XXX
