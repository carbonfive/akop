multiSelectDirective = (KeymapUtils, MultiSelect) ->
  restrict: 'A'
  link: ($scope, el, attrs) ->
    $scope.$watch attrs['akopMultiSelect'], (items) ->
      $scope.multiSelect = new MultiSelect(items || [])

    $scope.$watch attrs['selectableName'], ->
      $scope.selectableName = attrs.selectableName

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
        if e.shiftKey
          $(el).addClass('akop-noselect')
        for combo, funct of $scope.keymap
          if KeymapUtils.comboEventMatch(combo, e)
            e.preventDefault()
            funct.call()

    el.bind 'keyup', (e) ->
      $scope.$apply ->
        if e.shiftKey
          $(el).removeClass('akop-noselect')

    el.bind 'click', (e) ->
      item = angular.element(e.target).scope()[$scope.selectableName]
      $scope.$apply ->
        if e.shiftKey
          $scope.multiSelect.includeUntil(item)
        else if e.metaKey
          if item.selected
            $scope.multiSelect.exclude(item, false)
          else
            $scope.multiSelect.include(item, false)
        else
          $scope.multiSelect.reset(item)


multiSelectDirective.$inject = ['KeymapUtils', 'MultiSelect']
angular.module('akop-multi-select').directive 'akopMultiSelect', multiSelectDirective
