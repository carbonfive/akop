describe 'MultiSelectDirective', ->

  describe 'link', ->
    beforeEach ->
      @mockMultiSelect = jasmine.createSpy('MultiSelect')

      module 'akop', ($provide) =>
        $provide.value 'MultiSelect', @mockMultiSelect
        null

      inject (@$rootScope, @$compile) =>
        @scope = @$rootScope.$new()
        @compile = (markup, scope) ->
          el = @$compile(markup)(scope)
          scope.$digest()
          el

    it 'creates a new multiselect from items', ->
      @scope.some_collection = [{a: 'a'}, {b: 'b'}]
      @compile('<ul akop-multi-select="{items: some_collection}"></ul>', @scope)
      expect(@mockMultiSelect).toHaveBeenCalledWith(@scope.some_collection)

    it 'accepts a keymap and sets it on scope.keymap', ->
      @scope.my_keymap = {'shift-n': 'somefunction'}
      @compile('<ul akop-multi-select="{keymap: my_keymap}"></ul>', @scope)
      expect(@scope.keymap['shift-n']).toEqual 'somefunction'

    it 'merges with existing keymap', ->
      @scope.keymap = {'shift-n': 'existing'}
      @scope.some_other_keymap = {'shift-e': 'passed in'}
      @compile('<ul akop-multi-select="{keymap: some_other_keymap}"></ul>', @scope)
      @expect(@scope.keymap['shift-n']).toEqual 'existing'
      @expect(@scope.keymap['shift-e']).toEqual 'passed in'

    it 'adds multiselect hotkeys to keymap', ->
      @compile('<ul akop-multi-select="{keymap: some_other_keymap}"></ul>', @scope)
      for combo in ['up', 'down', 'shift-up', 'shift-down', 'alt-down', 'alt-up']
        expect(@scope.keymap[combo]).toBeDefined()

  describe 'keydown interactions', ->
    beforeEach ->
      module 'akop'
      inject (@$rootScope, @$compile) =>
        @scope = @$rootScope.$new()
        @scope.items = [{},{},{},{},{}]

        @el = @$compile('<ul akop-multi-select="{items: items}"></ul>')(@scope)
        @scope.$digest()

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
