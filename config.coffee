sysPath = require 'path'
startsWith = (string, substring) ->
  string.lastIndexOf(substring, 0) is 0

exports.config =
  server:
    path: 'server.coffee'
  paths:
    'public': 'public'
