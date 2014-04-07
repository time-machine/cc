# List of the BCP-47 language codes
# https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry
# Sort according to language popularity on Internet
# http://en.wikipedia.org/wiki/Languages_used_on_the_Internet

module.exports =
  en: require './en'             # English - English
  'en-US': require './en-US'     # English (US), English (US)
  zh: require './zh'             # 中文, Chinese
