queryFilter = ($filter) ->
  (list, expression) ->
    group_by = expression.group_by
    delete expression.group_by

    expressions = []

    array_args = _.compact(({attr: attr, arg: arg} if _.isArray(arg)) for attr, arg of expression)
    if array_args.length
      for arg_obj in array_args
        for val in arg_obj.arg
          exp = {}
          exp[arg_obj.attr] = val
          delete expressions[arg_obj.attr]
          expressions.push exp

    results =
      if angular.equals(expression, {})
        list
      else
        expressions.push expression
        _.flatten(_.reduceRight(expressions, (res, exp) =>
          res.push $filter('filter')(list, exp, true)
          res
        , []))

    return results unless group_by
    if _.any(list, (element) -> element[group_by] == undefined)
      throw new Error("serviceQueryFilter: Missing group_by property \"#{group_by}\" for some or all elements in list.")
    _.groupBy(results, group_by)

queryFilter.$inject = ['$filter']
angular.module('akop-query-filter').filter 'query', queryFilter
