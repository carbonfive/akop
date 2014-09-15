temperatureFilter = ->
  toFahrenheit = (degCelsius) ->
    (degCelsius * 9) / 5 + 32

  toKelvin = (degCelsius) ->
    degCelsius + 273.15

  scaleSymbol = (scale) ->
    switch scale
      when 'C'
        '°C'
      when 'F'
        '°F'
      when 'K'
        '°K'
      else
        null

  scaleValue = (temperature, scale) ->
    switch scale
      when 'C'
        temperature
      when 'F'
        toFahrenheit(temperature)
      when 'K'
        toKelvin(temperature)
      else
        temperature

  (temperature, scale = 'C') ->
    symbol  = scaleSymbol(scale)
    value   = scaleValue(temperature, scale)
    return temperature unless symbol
    "#{value} #{symbol}"

angular.module('akop-temperature-filter').filter 'temperature', temperatureFilter
