queryParser = () ->
  (query) ->
    return query if query == Object(query)

    return query unless query.split(":").length > 1

    pattern = /(\w+):((\w+)|(\[.*\])|"(.*)")/g

    matches = []
    matches.push match while match = pattern.exec(query)

    obj = {}
    for match in matches
      key = match[1]
      val = match[5] || match[2]
      val_arr = val.match(/\[(.*)\]/)
      if val_arr
        vals = val_arr[1].split(",")
        obj[key] = ("#{v}" for v in vals)
      else
        obj[key] = "#{val}"
    obj


angular.module('akop-query-filter').factory 'akopParser', queryParser
