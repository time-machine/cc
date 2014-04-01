locale = require '../app/locale/locale' # requiring from app; will break if we stop serving from where app lives
languages = []

module.exports.languages = languages
# TODO: module.exports.languageCodesLower = languageCodesLower = (code.)

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
    #
  return 'en-US'
