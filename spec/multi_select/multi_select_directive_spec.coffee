describe 'MultiSelectDirective', ->
  describe 'link', ->
    beforeEach module 'akop', ($provide) ->
      $provide.value 'MultiSelect', jasmine.createSpy('MultiSelect')
      null

    beforeEach inject ($rootScope, $compile) ->
      @scope = $rootScope.$new()
      @el = $compile('<ul akop-multi-select="items"></ul>')(@scope)
      $rootScope.$digest()

    it 'creates a new MultiSelect from Items', inject (MultiSelect, $rootScope) ->
      @scope.items = [{id: '1'}, {id: '2'}]
      $rootScope.$digest()
      expect(MultiSelect).toHaveBeenCalledWith(@scope.items)

  describe 'interactions', ->
    beforeEach module 'akop'
    beforeEach inject ($rootScope, $compile) ->
      @scope = $rootScope.$new()

      @el = $compile('<ul akop-multi-select="items"><li ng-repeat="item in items">{{item.id}}</li></ul>')(@scope)
      @scope.$digest()

    describe 'keydown interactions', ->
      it 'listens for up', ->
        spyOn(@scope.multiSelect, 'selectPrev')
        up = Factory.build('event', {keyCode: 38})
        @el.trigger(up)
        expect(@scope.multiSelect.selectPrev).toHaveBeenCalled()

      it 'listens for down', ->
        spyOn(@scope.multiSelect, 'selectNext')
        down = Factory.build('event', {keyCode: 40})
        @el.trigger(down)
        expect(@scope.multiSelect.selectNext).toHaveBeenCalled()

      it 'listens for shift-up', ->
        spyOn(@scope.multiSelect, 'moveToPrev')
        shiftUp = Factory.build('event', {keyCode: 38, shiftKey: true})
        @el.trigger(shiftUp)
        expect(@scope.multiSelect.moveToPrev).toHaveBeenCalled()

      it 'listens for shift-down', ->
        spyOn(@scope.multiSelect, 'moveToNext')
        shiftDown = Factory.build('event', {keyCode: 40, shiftKey: true})
        @el.trigger(shiftDown)
        expect(@scope.multiSelect.moveToNext).toHaveBeenCalled()

      it 'listens for alt-up', ->
        spyOn(@scope.multiSelect, 'selectFirst')
        altUp = Factory.build('event', {keyCode: 38, altKey: true})
        @el.trigger(altUp)
        expect(@scope.multiSelect.selectFirst).toHaveBeenCalled()

      it 'listens for alt-down', ->
        spyOn(@scope.multiSelect, 'selectLast')
        altDown = Factory.build('event', {keyCode: 40, altKey: true})
        @el.trigger(altDown)
        expect(@scope.multiSelect.selectLast).toHaveBeenCalled()
