queryParser = () ->
  (query) ->
    return query if query == Object(query)
    return query unless query.split(":").length > 1

    pattern = /(\w+):((\w+)|(\[.*\])|"(.*)")/g

    matches = []
    matches.push match while match = pattern.exec(query)

    strip = (v) ->
      String(v).replace /^[\s\"]+|[\s\"]+$/g, ''

    expression = {}
    for match in matches
      key = match[1]
      val = match[5] || match[2]
      val_arr = val.match(/\[(.*)\]/)
      if val_arr
        vals = val_arr[1].split(",")
        expression[key] = ("#{strip(v)}" for v in vals)
      else
        expression[key] = "#{val}"
    expression


angular.module('akop-query-filter').factory 'akopParser', queryParser
