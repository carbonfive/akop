describe 'QueryParser', ->
  beforeEach module 'akop-query-filter', ->

  beforeEach inject (@akopParser) ->

  describe 'parse', ->
    describe 'given an object', ->
      it 'returns the object', ->
        o = {name: 'Jasmine'}
        expect(@akopParser(o)).toBe o

  describe 'given a string with no : separator', ->
    it 'returns the string', ->
      exp = 'some string'
      expect(@akopParser(exp)).toBe exp

  describe 'given a string with : separator', ->
    it 'returns an object', ->
      exp = 'ay:bee see:dee'
      expect(@akopParser(exp)).toEqual { ay:"bee", see:"dee" }

  describe 'given a string with an array value', ->
    it 'returns the value as an array of string', ->
      exp = 'a:[1,two]'
      expect(@akopParser(exp)).toEqual { a: ["1", "two"] }

  describe 'given a quoted string with', ->
    it 'returns the value as expected', ->
      exp = 'name:"Joe Blow"'
      expect(@akopParser(exp)).toEqual {name: "Joe Blow"}
