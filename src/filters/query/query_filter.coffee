queryFilter = ($filter, parse, utils) ->

  flt = (exps, lst, filtered = []) ->
    while exps.length
      matching = $filter('filter')(lst, exps.pop(), true)
      filtered.push matching
      flt exps, _(lst).without(matching...), filtered
    _(filtered).flatten()

  (list, expression) ->
    expression = parse(expression)

    group_by = expression.group_by
    delete expression.group_by

    array_arguments = utils.getArrayArguments(expression)
    array_results = flt(utils.arrayArgsToExpressions(expression), list)

    results =
      if array_arguments.length > 0
        flt([expression], array_results)
      else
        flt([expression], list)

    return results unless group_by
    if _.any(list, (element) -> element[group_by] == undefined)
      throw new Error("serviceQueryFilter: Missing group_by property \"#{group_by}\" for some or all elements in list.")
    _.groupBy(results, group_by)

queryFilter.$inject = ['$filter', 'akopParser', 'expressionUtils']
angular.module('akop-query-filter').filter 'akopQuery', queryFilter
