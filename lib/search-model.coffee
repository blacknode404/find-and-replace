EventEmitter = require 'event-emitter'
_ = require 'underscore'
require 'underscore-extensions'

# Holds the current search pattern and search options. Does not run the search
# on a buffer. Just holds the parameter state. See {SearchResultsModel}
module.exports =
class SearchModel
  _.extend @prototype, EventEmitter

  # options -
  #   regex: false
  #   caseSensitive: false
  #   inWord: false
  #   inSelection: false
  constructor: (@options={}) ->
    @pattern = ''
    @results = {}
    @resultsVisible = false

  serialize: ->
    options: @options

  setOption: (key, value) ->
    return if @options[key] == value
    @options[key] = value
    @update()

  getOption: (key) ->
    @options[key]

  setPattern: (pattern='') ->
    return if @pattern == pattern
    @pattern = pattern
    @update()

  update: ->
    regex = @getRegex()
    @trigger 'change', { regex }

  getRegex: ->
    flags = 'g'
    flags += 'i' unless @options.caseSensitive

    if @options.regex
      new RegExp(@pattern, flags)
    else
      escapedPattern = _.escapeRegExp(@pattern)
      new RegExp(escapedPattern, flags)
