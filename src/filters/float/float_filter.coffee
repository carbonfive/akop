floatFilter = ->
  (float, precision) ->
    return float unless (typeof precision != 'undefined')
    multiplier = Math.pow(10, precision)
    Math.round(float * multiplier) / multiplier

angular.module('akop-float-filter').filter 'float', floatFilter
