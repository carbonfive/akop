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
      @items = [{id: '1'}, {id: '2'}]
      @scope.items = @items

      @el = $compile('
        <ul akop-multi-select="items" selectable-name="item">
          <li ng-repeat="item in items">{{item.id}}</li>
        </ul>'
      )(@scope)

      $rootScope.$digest()

    describe 'keydown', ->
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

      it 'listens for esc', ->
        spyOn(@scope.multiSelect, 'reset')
        esc = Factory.build('event', {keyCode: 27})
        @el.trigger(esc)
        expect(@scope.multiSelect.reset).toHaveBeenCalled()

    describe 'mouse', ->
      it 'includes with shift-click', ->
        spyOn(@scope.multiSelect, 'includeUntil')
        shiftClick = Factory.build('event', {type: 'click', shiftKey: true})
        $('li:last-child', @el).trigger shiftClick
        expect(@scope.multiSelect.includeUntil).toHaveBeenCalledWith(@items[1])

      it 'selects unselected click-target with meta-click', ->
        spyOn(@scope.multiSelect, 'include')
        metaClick = Factory.build('event', {type: 'click', metaKey: true})
        $('li:last-child', @el).trigger metaClick
        expect(@scope.multiSelect.include).toHaveBeenCalledWith(@items[1], false)

      it 'deselects selected click-target with meta-click', ->
        @scope.$apply => @scope.items[1].selected = true
        spyOn(@scope.multiSelect, 'exclude')
        metaClick = Factory.build('event', {type: 'click', metaKey: true})
        $('li:last-child', @el).trigger metaClick
        expect(@scope.multiSelect.exclude).toHaveBeenCalledWith(@items[1], false)

      it 'selects with click', ->
        spyOn(@scope.multiSelect, 'reset')
        click = Factory.build('event', {type: 'click'})
        $('li:last-child', @el).trigger click
        expect(@scope.multiSelect.reset).toHaveBeenCalledWith(@items[1])

      it 'suppresses text highlighting on shift down (for shift-click)', ->
        shiftDown = Factory.build('event', {type: 'keydown', shiftKey: true})
        $(@el).trigger shiftDown
        expect($(@el).hasClass('akop-noselect')).toBeTruthy()

      it 'stop suppression of text highlighting on shift up', ->
        shiftDown = Factory.build('event', {type: 'keydown', shiftKey: true})
        shiftUp = Factory.build('event', {type: 'keyup', shiftKey: true})
        $(@el).trigger shiftDown
        $(@el).trigger shiftUp
        expect($(@el).hasClass('akop-noselect')).toBeFalsy()
