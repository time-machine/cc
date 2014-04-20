c = require './common'

LevelSessionSchema = c.object {
  title: 'Session'
  description: 'A single session for a give level.'
}

module.exports = LevelSessionSchema
