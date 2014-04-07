locale = require '../app/locale/locale' # requiring from app; will break if we stop serving from where app lives

module.exports.setupRoutes = (app) ->
  app.all '/languages/add/:lang/:namespace', (req, res) ->
    console.log 'TD: languages setupRoutes1'

  app.all '/languages', (req, res) ->
    console.log 'TD: languages setupRoutes2'

languages = []
for code, localeInfo of locale
  languages.push code: code, nativeDescription: localeInfo.nativeDescription, englishDescription: localeInfo.englishDescription

module.exports.languages = languages
module.exports.languageCodes = languageCodes = (language.code for language in languages)
module.exports.languageCodesLower = languageCodesLower = (code.toLowerCase() for code in languageCodes)

# keep keys lower-case for matching and values with second subtag uppercase like i18next expects
languageAliases =
  'en': 'en-US'

  'zh-cn': 'zh-HANS'
  'zh-hans-cn': 'zh-HANS'
  'zh-sg': 'zh-HANS'
  'zh-hans-sg': 'zh-HANS'

  'zh-tw': 'zh-HANT'
  'zh-hant-tw': 'zh-HANT'
  'zh-hk': 'zh-HANT'
  'zh-hant-hk': 'zh-HANT'
  'zh-mo': 'zh-HANT'
  'zh-hant-mo': 'zh-HANT'

module.exports.languageCodeFromAcceptedLanguages = languageCodeFromAcceptedLanguages = (acceptedLanguages) ->
  for lang in acceptedLanguages ? []
    code = languageAliases[lang.toLowerCase()]
    return code if code
    codeIndex = _.indexOf languageCodesLower, lang
    if codeIndex isnt -1
      return languageCodes[codeIndex]
  return 'en-US'
