module.exports.loadObjectFromStorage = (key) ->
  s = localStorage.getItem(key)
  return null unless s
  try
    value = JSON.parse(s)
    return value
  catch e
    console.warning 'error loading from storage', key
    return null
