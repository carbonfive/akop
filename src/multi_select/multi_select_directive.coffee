multiSelectDirective = (KeymapUtils, MultiSelect, $parse) ->
  restrict: 'A'
  link: ($scope, el, attrs) ->
    self = $scope.$new()

    targetScope = (event) ->
      angular.element(event.target).scope()

    self.getSelection = (event) ->
      $parse(attrs['selectableName'])(targetScope(event))

    self.keymap =
      'up': -> $scope.multiSelect.selectPrev()
      'down': -> $scope.multiSelect.selectNext()
      'shift-up': -> $scope.multiSelect.moveToPrev()
      'shift-down': -> $scope.multiSelect.moveToNext()
      'alt-down': -> $scope.multiSelect.selectLast()
      'alt-up': -> $scope.multiSelect.selectFirst()
      'esc': -> $scope.multiSelect.reset()

    $scope.$watch attrs['akopMultiSelect'], (items) ->
      $scope.multiSelect = new MultiSelect(items || [])

    $scope.multiSelectClickHandler = (event, item) ->
      if event.shiftKey
        $scope.multiSelect.includeUntil(item)
      else if event.metaKey
        $scope.multiSelect.toggle(item)
      else
        $scope.multiSelect.reset(item)

    el.bind 'keydown', (e) ->
      $scope.$apply ->
        $(el).addClass('akop-noselect') if e.shiftKey
        for combo, funct of self.keymap
          if KeymapUtils.comboEventMatch(combo, e)
            e.preventDefault()
            funct.call()

    el.bind 'keyup', (e) ->
      $scope.$apply ->
        $(el).removeClass('akop-noselect') if e.shiftKey

    el.bind 'click', (e) ->
      $scope.$apply ->
        $scope.multiSelectClickHandler(e, self.getSelection(e))

multiSelectDirective.$inject = ['KeymapUtils', 'MultiSelect', '$parse']
angular.module('akop-multi-select').directive 'akopMultiSelect', multiSelectDirective
