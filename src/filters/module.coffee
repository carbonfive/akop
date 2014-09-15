#= require_self
#= require query/module
#= require float/module
#= require temperature/module

filters = [
  'akop-query-filter',
  'akop-float-filter',
  'akop-temperature-filter'
]

angular.module('akop-filters', filters)
