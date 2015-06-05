buildList = ->
  [
    { name: 'one'   }
    { name: 'two'   }
    { name: 'three' }
    { name: 'four'  }
    { name: 'five'  }
    { name: 'six'   }
    { name: 'seven' }
  ]

describe 'MultiSelect', ->
  beforeEach module 'akop-multi-select'

  beforeEach ->
    @addMatchers
      toSelect: (list, element_indexes...) ->
        expected = []
        expected[idx] = list[idx] for idx in element_indexes
        _.isEqual @actual, expected

  describe 'constructor', ->
    it 'assigns root and list', inject (MultiSelect) ->
      list = buildList()
      root = list[2]
      multi = new MultiSelect(list, root)
      expect(multi.root).toEqual(root)
      expect(multi.list).toEqual(list)

    it 'throws an error if root is not a member of list', inject (MultiSelect) ->
      expect( => 
          new MultiSelect(buildList(), { name: 'one hundred' })
      ).toThrow new Error('MultiSelect: Element must be a member of list.')

    it 'sets the cursor to the position of root', inject (MultiSelect) ->
      list = buildList()
      root = list[2]
      multi = new MultiSelect(list, root)
      expect(multi.cursor).toEqual list.indexOf(root)

    it 'accepts a list with no root', inject (MultiSelect) ->
      list = buildList()
      multi = new MultiSelect(list)
      expect(multi.list).toEqual(list)
      expect(multi.root).toBeUndefined()
      expect(multi.cursor).toBeUndefined()

    describe 'when initialized with elements that have a selected property', ->
      it 'adds selects the elements', inject (MultiSelect) ->
        list = buildList()
        list[1].selected = true
        multi = new MultiSelect(list)
        expect(multi.selected).toEqual [undefined,list[1]]

  describe 'include', ->
    beforeEach inject (MultiSelect) ->
      @list = buildList()
      @root = @list[2]
      @multi = new MultiSelect(@list, @root)
      @item = @list[3]
      @selected = @multi.include(@item)

    it 'sets the selected property of the passed element to true', ->
      expect(@item.selected).toBe true

    it 'adds the passed element to .selected', ->
      expect(@multi.selected.indexOf @item).toBeGreaterThan 0

    it 'adds the element to the same index in .selected as it has in .list', ->
      expect(@multi.selected.indexOf @item).toEqual @list.indexOf(@item)

    it 'returns an array with the currently selected elments', ->
      expect(@selected).toEqual [undefined, undefined, @root, @item]

    it 'sets the cursor to the position of the new element', ->
      expect(@multi.cursor).toEqual @selected.indexOf(@item)

    it 'throws an error if passed element is not a member of list', ->
      expect( => 
          @multi.include({})
      ).toThrow new Error("MultiSelect: Element must be a member of list.")

    it 'returns false if passed an element that is not adjacent to the upper index of .selected', ->
      expect(@multi.include @list[5]).toBe false

    it 'returns false if passed an element that is not adjacent to the lower index of .selected', ->
      expect(@multi.include @list[0]).toBe false

    it 'accepts an adjacent element with an index less than the root', ->
      item = @list[1]
      expect(@multi.include item).toEqual [undefined, item, @root, @item]

  describe 'toggle', ->
    beforeEach inject (MultiSelect) ->
      @list = buildList()
      @root = @list[2]
      @multi = new MultiSelect(@list, @root)
      @item = @list[3]
      @multi.include(@item)

    it 'toggles the selected state of the given item', ->
      expect(@item.selected).toBe true

      @multi.toggle(@item)
      expect(@item.selected).toBe false

      @multi.toggle(@item)
      expect(@item.selected).toBe true


  describe 'includeUntil', ->
    describe 'given an element with a higher index than the cursor', ->
      beforeEach inject (MultiSelect) ->
        @list = buildList()
        @root = @list[2]
        @multi = new MultiSelect(@list, @root)
        @multi.includeUntil @list[6]

      it 'selects all elements with an index between the cursor and the given element', ->
        expect(@multi.selected).toSelect @list, 2, 3, 4, 5, 6

    describe 'given an element with a lower index than the cursor', ->
      beforeEach inject (MultiSelect) ->
        @list = buildList()
        @root = @list[5]
        @multi = new MultiSelect(@list, @root)
        @multi.includeUntil @list[1]

      it 'selects all elements with an index between the cursor and the given element', ->
        expect(@multi.selected).toSelect @list, 1, 2, 3, 4, 5

    describe 'given the element under the cursor', ->
      beforeEach inject (MultiSelect) ->
        @list = buildList()
        @root = @list[5]
        @multi = new MultiSelect(@list, @root)
        @multi.includeUntil(@list[5])

      it 'keeps the element selected', ->
        expect(@multi.selected).toSelect @list, 5

    describe 'given a list without selected items', ->
      beforeEach inject (MultiSelect) ->
        @list = buildList()
        @multi = new MultiSelect(@list)
        @multi.reset()
        @multi.includeUntil(@list[3])

      it 'selects only the given element', ->
        expect(@multi.selected).toSelect @list, 3

  describe 'exclude', ->
    beforeEach inject (MultiSelect) ->
      @list = buildList()
      @root = @list[2]
      @multi = new MultiSelect(@list, @root)
      @item3 = @list[3]
      @item4 = @list[4]
      @multi.include(@item3)
      @multi.include(@item4)
      @selected = @multi.exclude(@item4)

    it 'sets the selected property of the passed element to false', ->
      expect(@item4.selected).toBe false

    it 'removes the passed element from selected', ->
      expect(@multi.selected.indexOf @item4).toEqual -1

    it 'returns an array with the currently selected elements', ->
      expect(@selected).toEqual [undefined, undefined, @root, @item3]

    it 'sets the cursor to the next adjacent selected element', ->
      expect(@multi.cursor).toEqual @selected.indexOf(@item3)

    it 'returns false if passed an element this is not on the outer bounds of selected', ->
      @multi.include(@item4)
      expect(@multi.exclude @item3).toBe false

    describe 'for non-adjacent elements', ->
      beforeEach inject (MultiSelect) ->
        @list = buildList()
        @multi = new MultiSelect(@list, @list[1])
        @multi.include(@list[4], false)
        @selected = @multi.exclude(@list[4], false)

      it 'sets the selected property of the passed element to false', ->
        expect(@item4.selected).toBe false

      it 'removes the passed element from selected', ->
        expect(@multi.selected.indexOf @list[4]).toEqual -1

      it 'sets the cursor to the next closest selected element', ->
        expect(@multi.cursor).toEqual @selected.indexOf(@list[1])

  describe 'reset with item', ->
    beforeEach inject (MultiSelect) ->
      @list = buildList()
      @item4 = @list[4]
      @multi = new MultiSelect(@list)
      @item4 = @list[4]
      @multi.reset(@item4)

    it 'sets the root to the given element', ->
      expect(@multi.root).toEqual @item4

    it 'sets root to the only member of .selected', ->
      expect(@multi.selected).toEqual [undefined, undefined, undefined, undefined, @item4]

    it 'sets the selected property of the given element to true', ->
      expect(@item4.selected).toBe true

    it 'sets the selected property of all other elements to false', ->
      for element in @list
        expect(element.selected).toBeFalsy() unless element == @item4

  describe 'reset without item', ->
    beforeEach inject (MultiSelect) ->
      @list = buildList()
      @root = @list[2]
      @multi = new MultiSelect(@list, @root)

    it 'excludes all items', ->
      expect(@multi.selected).toEqual [undefined, undefined, @root]
      @multi.reset()
      expect(@multi.selected).toEqual []

  describe 'moveCursorTo', ->
    beforeEach inject (MultiSelect) ->
      @list = buildList()
      @root = @list[2]
      @multi = new MultiSelect(@list, @root)

    it 'selects element under cursor if it is not selected', ->
      item = @list[3]
      @multi.moveCursorTo(3)
      expect(item.selected).toBe true

    it 'deselects the elements outside of the selected bounds', ->
      item4 = @list[4]
      @multi.moveCursorTo(3)
      @multi.moveCursorTo(4)
      @multi.moveCursorTo(3)
      expect(item4.selected).toBe false

    it 'returns selected if asked to move cursor outside of list bounds', ->
      @multi.reset(@list[0])
      expect(@multi.moveCursorTo(@multi.cursor - 1)).toSelect @list, 0
      @multi.reset(_.last @list)
      expect(@multi.moveCursorTo(@list.length)).toSelect @list, 6

    it 'works desceding and then ascending', ->
      @multi.reset(@list[5])
      @multi.moveCursorTo(4)
      @multi.moveCursorTo(3)
      @multi.moveCursorTo(2)
      @multi.moveCursorTo(1)
      @multi.moveCursorTo(2)
      expect(@multi.moveCursorTo(3)).toSelect @list, 3,4,5

  describe 'selectPrev', ->
    it 'selects the last element if no element is selected', inject (MultiSelect) ->
      list = buildList()
      multi = new MultiSelect(list, @root)
      expect(multi.selectPrev()).toSelect list, 6

    it 'selects the previous adjacent element', inject (MultiSelect) ->
      list = buildList()
      root = list[2]
      multi = new MultiSelect(list, root)
      multi.selectPrev()
      expect(multi.selected).toEqual [undefined, list[1]]

    it 'selects the last element if the current element is the first', inject (MultiSelect) ->
      list = buildList()
      root = list[0]
      multi = new MultiSelect(list, root)
      expect(multi.selectPrev()).toSelect list, 6

  describe 'selectNext', ->
    it 'selects the first element if no element is selected', inject (MultiSelect) ->
      list = buildList()
      multi = new MultiSelect(list)
      expect(multi.selectNext()).toSelect list, 0

    it 'selects the next adjacent element', inject (MultiSelect) ->
      list = buildList()
      root = list[2]
      multi = new MultiSelect(list, root)
      expect(multi.selectNext()).toSelect list, 3

    it 'selects the first element if the current element is last', inject (MultiSelect) ->
      list = buildList()
      root = _.last(list)
      multi = new MultiSelect(list, root)
      expect(multi.selectNext()).toSelect list, 0

  describe 'moveToPrev', ->
    it 'expands the selection to include the prev adjacent element', inject (MultiSelect) ->
      list = buildList()
      root = list[2]
      multi = new MultiSelect(list, root)
      expect(multi.moveToPrev()).toSelect list, 1, 2

    it 'does not wrap around to the top of the list', inject (MultiSelect) ->
      list = buildList()
      multi = new MultiSelect(list, list[0])
      expect(multi.moveToPrev()).toSelect list, 0

  describe 'moveToNext', ->
    it 'expands the selection to include the next adjacent element', inject (MultiSelect) ->
      list = buildList()
      multi = new MultiSelect(list, list[2])
      multi.moveToNext()
      expect(multi.selected).toSelect list, 2, 3

    it 'does not wrap around to the bottom of the list', inject (MultiSelect) ->
      list = buildList()
      multi = new MultiSelect(list, list[6])
      multi.moveToNext()
      expect(multi.selected).toSelect list, 6


