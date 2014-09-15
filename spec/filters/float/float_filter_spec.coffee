describe 'float filter', ->
  beforeEach module 'akop-float-filter'

  it 'returns the number if no precision is given', inject ($filter) ->
    input = 1.23456
    output = $filter('float') input
    expect(output).toEqual input

  it 'rounds to the given precision', inject ($filter) ->
    input = 1.23456
    precision = 2
    output = $filter('float') input, precision
    expect(output).toEqual 1.23

  it 'rounds to the last significant digit', inject ($filter) ->
    input = 1.230000000000
    precision = 6
    output = $filter('float') input, precision
    expect(output).toEqual 1.23
