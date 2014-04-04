c = require './common'

UserSchema = c.object {},
  name: c.shortString({title: 'Display Name', default: ''})

console.log 'us', UserSchema
module.exports = UserSchema
