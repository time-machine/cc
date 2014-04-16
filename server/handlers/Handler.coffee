module.exports = class Handler
  # subclasses should overried these properties
  modelClass: null
  editableProperties: []

  # subclasses should overried these methods
  hasAccess: (req) -> true
