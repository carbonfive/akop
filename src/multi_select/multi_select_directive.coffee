multiSelectDirective = (KeymapUtils, MultiSelect, $parse) ->
  restrict: 'A'
  link: ($scope, el, attrs) ->
    $scope.$watch attrs['akopMultiSelect'], (items) ->
      $scope.multiSelect = new MultiSelect(items || [])

    $scope.keymap =
      'up': -> $scope.multiSelect.selectPrev()
      'down': -> $scope.multiSelect.selectNext()
      'shift-up': -> $scope.multiSelect.moveToPrev()
      'shift-down': -> $scope.multiSelect.moveToNext()
      'alt-down': -> $scope.multiSelect.selectLast()
      'alt-up': -> $scope.multiSelect.selectFirst()
      'esc': -> $scope.multiSelect.reset()

    el.bind 'keydown', (e) ->
      $scope.$apply ->
        for combo, funct of $scope.keymap
          if KeymapUtils.comboEventMatch(combo, e)
            e.preventDefault()
            funct.call()

multiSelectDirective.$inject = ['KeymapUtils', 'MultiSelect', '$parse']
angular.module('akop-multi-select').directive 'akopMultiSelect', multiSelectDirective
