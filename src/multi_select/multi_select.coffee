class MultiSelect
  constructor: (@list, @root) ->
    @reset @root if @root

  reset: (@root) ->
    _.each @list, (el) -> el.selected = false
    @selected = []
    @include(@root, false)

  include: (el, enforce_adjacency = true) ->
    pos = @_pos(el)
    throw new Error("MultiSelect: Element must be a member of list.") if pos < 0
    return false if enforce_adjacency and not @_isAdjacent(pos)
    el.selected = true
    @selected[pos] = el
    @cursor = pos
    @selected

  exclude: (el) ->
    pos = @_pos(el)
    is_upper = @_is_upper(pos)
    is_lower = @_is_lower(pos)
    return false unless is_upper or is_lower
    el.selected = false
    if is_upper
      @selected.pop()
      @cursor = @_upper_index()
    else
      @selected.splice(@_lower_index(), 1, undefined)
      @cursor = @_lower_index()
    @selected

  moveCursorTo: (index) ->
    return @selected if index < 0 or index > @list.length - 1
    el = @list[index]
    if el.selected
      step = if @_is_desc(index, @cursor) then 1 else -1
      @exclude(@list[index + step])
    else
      @include(el)

  selectPrev: =>
    if @cursor? == false or @cursor == 0
      @reset(_.last @list)
    else
      @reset(@list[@cursor - 1])

  selectNext: =>
    if @cursor? == false or @cursor == @list.length - 1
      @reset(@list[0])
    else
      @reset(@list[@cursor + 1])

  selectLast: =>
    @reset(_.last(@list))

  selectFirst: =>
    @reset(_.first(@list))

  moveToPrev: =>
    @moveCursorTo(@cursor - 1)

  moveToNext: =>
    @moveCursorTo(@cursor + 1)

  _is_asc: (current_idx, prev_idx) ->
    current_idx - prev_idx == 1

  _is_desc: (current_idx, prev_idx) ->
    current_idx - prev_idx == -1

  _pos: (el) ->
    @list.indexOf(el)

  _isAdjacent: (pos) ->
    pos - 1 == @_upper_index() || pos + 1 == @_lower_index()

  _upper_index: ->
    @selected.length - 1

  _lower_index: ->
    occupied = _.filter @selected, (el) -> el
    @selected.indexOf(_.first occupied)

  _is_upper: (index) ->
    @_upper_index() == index

  _is_lower: (index) ->
    @_lower_index() == index

angular.module('akop-multi-select').factory 'MultiSelect', -> MultiSelect
