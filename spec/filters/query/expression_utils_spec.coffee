describe 'expressionUtils', ->
  beforeEach module 'akop-query-filter'

  beforeEach inject ['expressionUtils', (@utils) ->]

  describe 'getArrayArguments', ->
    it 'returns the arguments as an array of objects with attr and arg values', ->
      exp = a: 1, b: [1,2,3], c: "hello"
      expect(@utils.getArrayArguments(exp)).toEqual [
        attr: 'b', arg: [1,2,3]
      ]

  describe 'arrayArgsToExpressions', ->
    it 'creates an expression for each value in an array argument', ->
      exp = a: 1, b: [1,2,3], c: "hello"
      expect(@utils.arrayArgsToExpressions(exp)).toEqual [
        {b: 1}, {b: 2}, {b: 3}
      ]
