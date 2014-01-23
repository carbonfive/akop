describe 'QueryFilter', ->
  beforeEach module 'akop-query-filter', ->

  beforeEach inject ($filter) ->
    @filter = $filter('akop-query')

    @list = [
      {id: 1, name: 'Workit',  fk_id: 1},
      {id: 2, name: 'Fandroo', fk_id: 1},
      {id: 3, name: 'Lendry',  fk_id: 2},
      {id: 4, name: 'Workit',  fk_id: 2},
    ]

  describe 'with no arguments', ->
    it 'returns the whole list', ->
      expect(@filter @list, {}).toEqual @list

  describe 'when querying on an attribute', ->
    beforeEach ->
      @filtered = @filter(@list, fk_id: 1)

    it 'returns all matching list items', ->
      expect(@filtered.length).toBe 2

    it 'returns only matching list items', ->
      expect(result.fk_id).toBe 1 for result in @filtered

  describe 'when querying by multiple attrs', ->
    beforeEach ->
      @filtered = @filter(@list, name: 'Workit', fk_id: 1)

    it 'returns all matching list items', ->
      expect(@filtered.length).toBe 1

    it 'returns only matching list items', ->
      expect(@filtered[0]).toEqual @list[0]

  describe 'when expression includes a group_by attribute', ->
    describe 'and the list has the given attribute', ->
      beforeEach ->
        @filtered = @filter(@list, group_by: 'name')

      it 'has top level keys for the given group_by attr', ->
        keys = (key for key, val of @filtered)
        expect(keys).toEqual ['Workit', 'Fandroo', 'Lendry']

      it 'has matching list members', ->
        expect(@filtered['Workit']).toEqual [@list[0], @list[3]]

    describe 'and the list members do not have the given attribute', ->
      it 'throws an error', ->
        expect( => @filter(@list, group_by: 'xyz')).toThrow(
          new Error("serviceQueryFilter: Missing group_by property \"xyz\" for some or all elements in list.")
        )

  describe "when expression includes multiple values for a given attribute", ->
    it 'returns all matching items', ->
      filtered = @filter @list, id: [1, 2]
      expect(filtered.length).toEqual 2
      expect(filtered.indexOf @list[0]).not.toBe -1
      expect(filtered.indexOf @list[1]).not.toBe -1

  describe "when given a string for an argument", ->
    it 'works the same as if given an object', ->
      filtered = @filter @list, "fk_id:1"
      expect(filtered.length).toBe 2
