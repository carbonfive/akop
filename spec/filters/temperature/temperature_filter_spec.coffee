describe 'temperatureFilter', ->
  beforeEach module 'akop-temperature-filter'

  beforeEach inject ($filter) ->
    @filter = $filter('temperature')

  it 'appends a unit', ->
    expect(@filter(1.23)).toEqual '1.23 °C'

  it 'converts value from celsius to fahrenheit when given fahrenheit as a scale', ->
    expect(@filter(0, 'F')).toEqual '32 °F'

  it 'converts from celsius to kelvin when given kelvin as a scale', ->
    expect(@filter(0, 'K')).toEqual '273.15 °K'

  it 'returns the unmodified input when given any other value for scale', ->
    expect(@filter(123, 'phrygian')).toEqual 123
