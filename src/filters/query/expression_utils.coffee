class ExpressionUtils
  getArrayArguments: (expression) ->
    _.compact(({attr: attr, arg: arg} if _.isArray(arg)) for attr, arg of expression)

  arrayArgsToExpressions: (expression) ->
    expressions = []
    for arg_obj in @getArrayArguments(expression)
      for val in arg_obj.arg
        exp = {}
        exp[arg_obj.attr] = val
        delete expression[arg_obj.attr]
        expressions.push exp
    expressions

angular.module('akop-query-filter').service 'expressionUtils', ExpressionUtils
