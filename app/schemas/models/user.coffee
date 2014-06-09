c = require './../schemas'
emailSubscriptions = ['announcement', 'tester', 'level_creator', 'developer', 'article_editor', 'translator', 'support', 'notification']

UserSchema = c.object {},
  name: c.shortString({title: 'Display Name', default:''})
  email: c.shortString({title: 'Email', format: 'email'})
  firstName: c.shortString({title: 'First Name'})
  lastName: c.shortString({title: 'Last Name'})
  gender: {type: 'string', 'enum': ['male', 'female']}
  password: {type: 'string', maxLength: 256, minLength: 2, title:'Password'}
  passwordReset: {type: 'string'}
  photoURL: {type: 'string', format: 'image-file', title: 'Profile Picture', description: 'Upload a 256x256px or larger image to serve as your profile picture.'}

  facebookID: c.shortString({title: 'Facebook ID'})
  gplusID: c.shortString({title: 'G+ ID'})

  wizardColor1: c.pct({title: 'Wizard Clothes Color'})
  volume: c.pct({title: 'Volume'})
  music: {type: 'boolean', default: true}
  autocastDelay: {type: 'integer', 'default': 5000 }
  lastLevel: { type: 'string' }

  emailSubscriptions: c.array {uniqueItems: true}, {'enum': emailSubscriptions}
  emails: c.object {title: "Email Settings", default: {generalNews: {enabled:true}, anyNotes: {enabled:true}, recruitNotes: {enabled:true}}},
    # newsletters
    generalNews: { $ref: '#/definitions/emailSubscription' }
    adventurerNews: { $ref: '#/definitions/emailSubscription' }
    ambassadorNews: { $ref: '#/definitions/emailSubscription' }
    archmageNews: { $ref: '#/definitions/emailSubscription' }
    artisanNews: { $ref: '#/definitions/emailSubscription' }
    diplomatNews: { $ref: '#/definitions/emailSubscription' }
    scribeNews: { $ref: '#/definitions/emailSubscription' }

    # notifications
    anyNotes: { $ref: '#/definitions/emailSubscription' } # overrides any other notifications settings
    recruitNotes: { $ref: '#/definitions/emailSubscription' }
    employerNotes: { $ref: '#/definitions/emailSubscription' }

  # server controlled
  permissions: c.array {'default': []}, c.shortString()
  dateCreated: c.date({title: 'Date Joined'})
  anonymous: {type: 'boolean', 'default': true}
  testGroupNumber: {type: 'integer', minimum: 0, maximum: 256, exclusiveMaximum: true}
  mailChimp: {type: 'object'}
  hourOfCode: {type: 'boolean'}
  hourOfCodeComplete: {type: 'boolean'}

  emailLower: c.shortString()
  nameLower: c.shortString()
  passwordHash: {type: 'string', maxLength: 256}

  # client side
  #gravatarProfile: {} (should only ever be kept locally)
  emailHash: {type: 'string'}

  # Internationalization stuff
  preferredLanguage: {type: 'string', default: 'en', 'enum': c.getLanguageCodeArray()}

  signedCLA: c.date({title: 'Date Signed the CLA'})

c.extendBasicProperties UserSchema, 'user'

module.exports = UserSchema
