KeymapUtils = (KEYCODES) ->

  _arrayEqual = (a, b, enforce_order = true) ->
    a.sort() and b.sort() unless enforce_order
    a.length is b.length and a.every (elem, i) -> elem is b[i]

  _eventKeys = (event) ->
    keys = []
    keys.push codeFor('alt') if event.altKey
    keys.push codeFor('ctrl') if event.ctrlKey
    keys.push codeFor('shift') if event.shiftKey
    keys.push parseInt(event.keyCode)
    keys

  codeFor = (key) -> KEYCODES[key]

  parseCombo = (combo_string) ->
    _.map combo_string.split('-'), (key) -> codeFor(key)

  comboEventMatch = (combo_string, event) ->
    _arrayEqual(_eventKeys(event), parseCombo(combo_string), false)

  codeFor: codeFor
  parseCombo: parseCombo
  comboEventMatch: comboEventMatch

KeymapUtils.$inject = ['KEYCODES']
angular.module('akop-keymap').service 'KeymapUtils', KeymapUtils


