workingInterceptor = ($q, $rootScope, flash) ->
  $rootScope.requestCount = 0

  request: (config) ->
    $rootScope.requestCount += 1
    config

  requestError: (rejection) ->
    $rootScope.requestCount -= 1
    flash.error "HTTP Request Error: #{rejection}"
    rejection

  response: (response) ->
    $rootScope.requestCount -= 1
    response

  responseError: (rejection) ->
    $rootScope.requestCount -= 1
    flash.error "HTTP Response Error: #{rejection}"
    rejection

angular.module('akop-working-interceptor', []).config(['$httpProvider', ($httpProvider) ->
  $httpProvider.interceptors.push(workingInterceptor)
])

