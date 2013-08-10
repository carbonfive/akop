describe 'KeymapUtils', ->

  beforeEach ->
    module 'akop-keymap'
    inject (KeymapUtils) =>
      @Utils = KeymapUtils

  describe 'codeFor', ->
    it 'returns the keycode for a given character', ->
      expect(@Utils.codeFor '8').toEqual    56
      expect(@Utils.codeFor '\\').toEqual   220
      expect(@Utils.codeFor "'").toEqual    222
      expect(@Utils.codeFor 'ctrl').toEqual 17

  describe 'parseCombo', ->
    it 'returns an array of keycodes', ->
      expect(@Utils.parseCombo 'shift-3').toEqual [16, 51]
      expect(@Utils.parseCombo 'tab-1-z').toEqual [9, 49, 90]

  describe 'comboEventMatch', ->
    beforeEach ->
      @event = Factory.build('event', {shiftKey: true, keyCode: 69})

    it 'returns true when a combo matches an event', ->
      expect(@Utils.comboEventMatch 'shift-e', @event).toBe true

    it 'returns false when a combo does not match an event', ->
      expect(@Utils.comboEventMatch 'shift-d', @event).toBe false
