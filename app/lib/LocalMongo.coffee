LocalMongo = module.exports

# Checks whether func(l, r) is true for at least one value of left for at least one value of right
mapred = (left, right, func) ->
  console.log 'TD: mapred'

doQuerySelector = (value, operatorObj) ->
  console.log 'TD: doQuerySelector'

matchesQuery = (target, queryObj) ->
  console.log 'TD: matchesQuery'

LocalMongo.matchesQuery = matchesQuery
