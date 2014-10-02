(function() {
  describe('KeymapUtils', function() {
    beforeEach(function() {
      module('akop-keymap');
      return inject((function(_this) {
        return function(KeymapUtils) {
          return _this.Utils = KeymapUtils;
        };
      })(this));
    });
    describe('codeFor', function() {
      return it('returns the keycode for a given character', function() {
        expect(this.Utils.codeFor('8')).toEqual(56);
        expect(this.Utils.codeFor('\\')).toEqual(220);
        expect(this.Utils.codeFor("'")).toEqual(222);
        return expect(this.Utils.codeFor('ctrl')).toEqual(17);
      });
    });
    describe('parseCombo', function() {
      return it('returns an array of keycodes', function() {
        expect(this.Utils.parseCombo('shift-3')).toEqual([16, 51]);
        return expect(this.Utils.parseCombo('tab-1-z')).toEqual([9, 49, 90]);
      });
    });
    return describe('comboEventMatch', function() {
      beforeEach(function() {
        return this.event = Factory.build('event', {
          shiftKey: true,
          keyCode: 69
        });
      });
      it('returns true when a combo matches an event', function() {
        return expect(this.Utils.comboEventMatch('shift-e', this.event)).toBe(true);
      });
      return it('returns false when a combo does not match an event', function() {
        return expect(this.Utils.comboEventMatch('shift-d', this.event)).toBe(false);
      });
    });
  });

}).call(this);

(function() {
  describe('MultiSelectDirective', function() {
    describe('link', function() {
      beforeEach(function() {
        this.mockMultiSelect = jasmine.createSpy('MultiSelect');
        module('akop', (function(_this) {
          return function($provide) {
            $provide.value('MultiSelect', _this.mockMultiSelect);
            return null;
          };
        })(this));
        return inject((function(_this) {
          return function($rootScope, $compile) {
            _this.$rootScope = $rootScope;
            _this.$compile = $compile;
            _this.scope = _this.$rootScope.$new();
            return _this.compile = function(markup, scope) {
              var el;
              el = this.$compile(markup)(scope);
              scope.$digest();
              return el;
            };
          };
        })(this));
      });
      it('creates a new multiselect from items', function() {
        this.scope.some_collection = [
          {
            a: 'a'
          }, {
            b: 'b'
          }
        ];
        this.compile('<ul akop-multi-select="{items: some_collection}"></ul>', this.scope);
        return expect(this.mockMultiSelect).toHaveBeenCalledWith(this.scope.some_collection);
      });
      it('accepts a keymap and sets it on scope.keymap', function() {
        this.scope.my_keymap = {
          'shift-n': 'somefunction'
        };
        this.compile('<ul akop-multi-select="{keymap: my_keymap}"></ul>', this.scope);
        return expect(this.scope.keymap['shift-n']).toEqual('somefunction');
      });
      it('merges with existing keymap', function() {
        this.scope.keymap = {
          'shift-n': 'existing'
        };
        this.scope.some_other_keymap = {
          'shift-e': 'passed in'
        };
        this.compile('<ul akop-multi-select="{keymap: some_other_keymap}"></ul>', this.scope);
        this.expect(this.scope.keymap['shift-n']).toEqual('existing');
        return this.expect(this.scope.keymap['shift-e']).toEqual('passed in');
      });
      return it('adds multiselect hotkeys to keymap', function() {
        var combo, _i, _len, _ref, _results;
        this.compile('<ul akop-multi-select="{keymap: some_other_keymap}"></ul>', this.scope);
        _ref = ['up', 'down', 'shift-up', 'shift-down', 'alt-down', 'alt-up'];
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          combo = _ref[_i];
          _results.push(expect(this.scope.keymap[combo]).toBeDefined());
        }
        return _results;
      });
    });
    return describe('keydown interactions', function() {
      beforeEach(function() {
        module('akop');
        return inject((function(_this) {
          return function($rootScope, $compile) {
            _this.$rootScope = $rootScope;
            _this.$compile = $compile;
            _this.scope = _this.$rootScope.$new();
            _this.scope.items = [{}, {}, {}, {}, {}];
            _this.el = _this.$compile('<ul akop-multi-select="{items: items}"></ul>')(_this.scope);
            return _this.scope.$digest();
          };
        })(this));
      });
      it('listens for up', function() {
        var up;
        spyOn(this.scope.multiSelect, 'selectPrev');
        up = Factory.build('event', {
          keyCode: 38
        });
        this.el.trigger(up);
        return expect(this.scope.multiSelect.selectPrev).toHaveBeenCalled();
      });
      it('listens for down', function() {
        var down;
        spyOn(this.scope.multiSelect, 'selectNext');
        down = Factory.build('event', {
          keyCode: 40
        });
        this.el.trigger(down);
        return expect(this.scope.multiSelect.selectNext).toHaveBeenCalled();
      });
      it('listens for shift-up', function() {
        var shiftUp;
        spyOn(this.scope.multiSelect, 'moveToPrev');
        shiftUp = Factory.build('event', {
          keyCode: 38,
          shiftKey: true
        });
        this.el.trigger(shiftUp);
        return expect(this.scope.multiSelect.moveToPrev).toHaveBeenCalled();
      });
      it('listens for shift-down', function() {
        var shiftDown;
        spyOn(this.scope.multiSelect, 'moveToNext');
        shiftDown = Factory.build('event', {
          keyCode: 40,
          shiftKey: true
        });
        this.el.trigger(shiftDown);
        return expect(this.scope.multiSelect.moveToNext).toHaveBeenCalled();
      });
      it('listens for alt-up', function() {
        var altUp;
        spyOn(this.scope.multiSelect, 'selectFirst');
        altUp = Factory.build('event', {
          keyCode: 38,
          altKey: true
        });
        this.el.trigger(altUp);
        return expect(this.scope.multiSelect.selectFirst).toHaveBeenCalled();
      });
      return it('listens for alt-down', function() {
        var altDown;
        spyOn(this.scope.multiSelect, 'selectLast');
        altDown = Factory.build('event', {
          keyCode: 40,
          altKey: true
        });
        this.el.trigger(altDown);
        return expect(this.scope.multiSelect.selectLast).toHaveBeenCalled();
      });
    });
  });

}).call(this);

(function() {
  var __slice = [].slice;

  describe('MultiSelect', function() {
    beforeEach(function() {
      module('akop-multi-select');
      inject((function(_this) {
        return function(MultiSelect) {
          _this.MultiSelect = MultiSelect;
          _this.list = [
            {
              name: 'one'
            }, {
              name: 'two'
            }, {
              name: 'three'
            }, {
              name: 'four'
            }, {
              name: 'five'
            }, {
              name: 'six'
            }, {
              name: 'seven'
            }
          ];
          _this.root = _this.list[2];
          return _this.multi = new _this.MultiSelect(_this.list, _this.root);
        };
      })(this));
      return this.addMatchers({
        toSelect: function() {
          var element_indexes, expected, idx, list, _i, _len;
          list = arguments[0], element_indexes = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
          expected = [];
          for (_i = 0, _len = element_indexes.length; _i < _len; _i++) {
            idx = element_indexes[_i];
            expected[idx] = list[idx];
          }
          return _.isEqual(this.actual, expected);
        }
      });
    });
    describe('constructor', function() {
      it('assigns root and list', function() {
        expect(this.multi.root).toEqual(this.root);
        return expect(this.multi.list).toEqual(this.list);
      });
      it('throws an error if root is not a member of list', function() {
        return expect((function(_this) {
          return function() {
            return new _this.MultiSelect(_this.list, {
              name: 'one hundred'
            });
          };
        })(this)).toThrow(new Error('MultiSelect: Element must be a member of list.'));
      });
      it('sets the cursor to the position of root', function() {
        return expect(this.multi.cursor).toEqual(this.list.indexOf(this.root));
      });
      return it('accepts a list with no root', function() {
        var multi;
        multi = new this.MultiSelect(this.list);
        expect(multi.list).toEqual(this.list);
        expect(multi.root).toBeUndefined();
        return expect(multi.cursor).toBeUndefined();
      });
    });
    describe('include', function() {
      beforeEach(function() {
        this.item = this.list[3];
        return this.selected = this.multi.include(this.item);
      });
      it('sets the selected property of the passed element to true', function() {
        return expect(this.item.selected).toBe(true);
      });
      it('adds the passed element to .selected', function() {
        return expect(this.multi.selected.indexOf(this.item)).toBeGreaterThan(0);
      });
      it('adds the element to the same index in .selected as it has in .list', function() {
        return expect(this.multi.selected.indexOf(this.item)).toEqual(this.list.indexOf(this.item));
      });
      it('returns an array with the currently selected elments', function() {
        return expect(this.selected).toEqual([void 0, void 0, this.root, this.item]);
      });
      it('sets the cursor to the position of the new element', function() {
        return expect(this.multi.cursor).toEqual(this.selected.indexOf(this.item));
      });
      it('throws an error if passed element is not a member of list', function() {
        return expect((function(_this) {
          return function() {
            return _this.multi.include({});
          };
        })(this)).toThrow(new Error("MultiSelect: Element must be a member of list."));
      });
      it('returns false if passed an element that is not adjacent to the upper index of .selected', function() {
        return expect(this.multi.include(this.list[5])).toBe(false);
      });
      it('returns false if passed an element that is not adjacent to the lower index of .selected', function() {
        return expect(this.multi.include(this.list[0])).toBe(false);
      });
      return it('accepts an adjacent element with an index less than the root', function() {
        var item;
        item = this.list[1];
        return expect(this.multi.include(item)).toEqual([void 0, item, this.root, this.item]);
      });
    });
    describe('exclude', function() {
      beforeEach(function() {
        this.item3 = this.list[3];
        this.item4 = this.list[4];
        this.multi.include(this.item3);
        this.multi.include(this.item4);
        return this.selected = this.multi.exclude(this.item4);
      });
      it('sets the selected property of the passed element to false', function() {
        return expect(this.item4.selected).toBe(false);
      });
      it('removes the passed element from selected', function() {
        return expect(this.multi.selected.indexOf(this.item4)).toEqual(-1);
      });
      it('returns an array with the currently selected elements', function() {
        return expect(this.selected).toEqual([void 0, void 0, this.root, this.item3]);
      });
      it('sets the cursor to the next adjacent selected element', function() {
        return expect(this.multi.cursor).toEqual(this.selected.indexOf(this.item3));
      });
      return it('returns false if passed an element this is not on the outer bounds of selected', function() {
        this.multi.include(this.item4);
        return expect(this.multi.exclude(this.item3)).toBe(false);
      });
    });
    describe('reset with item', function() {
      beforeEach(function() {
        this.item4 = this.list[4];
        return this.multi.reset(this.item4);
      });
      it('sets the root to the given element', function() {
        return expect(this.multi.root).toEqual(this.item4);
      });
      it('sets root to the only member of .selected', function() {
        return expect(this.multi.selected).toEqual([void 0, void 0, void 0, void 0, this.item4]);
      });
      it('sets the selected property of the given element to true', function() {
        return expect(this.item4.selected).toBe(true);
      });
      return it('sets the selected property of all other elements to false', function() {
        return expect(this.root.selected).toBe(false);
      });
    });
    describe('moveCursorTo', function() {
      it('selects element under cursor if it is not selected', function() {
        var item;
        item = this.list[3];
        this.multi.moveCursorTo(3);
        return expect(item.selected).toBe(true);
      });
      it('deselects the elements outside of the selected bounds', function() {
        var item4;
        item4 = this.list[4];
        this.multi.moveCursorTo(3);
        this.multi.moveCursorTo(4);
        this.multi.moveCursorTo(3);
        return expect(item4.selected).toBe(false);
      });
      it('returns selected if asked to move cursor outside of list bounds', function() {
        this.multi.reset(this.list[0]);
        expect(this.multi.moveCursorTo(this.multi.cursor - 1)).toSelect(this.list, 0);
        this.multi.reset(_.last(this.list));
        return expect(this.multi.moveCursorTo(this.list.length)).toSelect(this.list, 6);
      });
      return it('works desceding and then ascending', function() {
        this.multi.reset(this.list[5]);
        this.multi.moveCursorTo(4);
        this.multi.moveCursorTo(3);
        this.multi.moveCursorTo(2);
        this.multi.moveCursorTo(1);
        this.multi.moveCursorTo(2);
        return expect(this.multi.moveCursorTo(3)).toSelect(this.list, 3, 4, 5);
      });
    });
    describe('selectPrev', function() {
      it('selects the last element if no element is selected', function() {
        this.multi = new this.MultiSelect(this.list);
        return expect(this.multi.selectPrev()).toSelect(this.list, 6);
      });
      it('selects the previous adjacent element', function() {
        this.multi.selectPrev();
        return expect(this.multi.selected).toEqual([void 0, this.list[1]]);
      });
      return it('selects the last element if the current element is the first', function() {
        this.multi = new this.MultiSelect(this.list, this.list[0]);
        return expect(this.multi.selectPrev()).toSelect(this.list, 6);
      });
    });
    describe('selectNext', function() {
      it('selects the first element if no element is selected', function() {
        this.multi = new this.MultiSelect(this.list);
        return expect(this.multi.selectNext()).toSelect(this.list, 0);
      });
      it('selects the next adjacent element', function() {
        return expect(this.multi.selectNext()).toSelect(this.list, 3);
      });
      return it('selects the first element if the current element is last', function() {
        this.multi.reset(_.last(this.list));
        return expect(this.multi.selectNext()).toSelect(this.list, 0);
      });
    });
    describe('moveToPrev', function() {
      it('expands the selection to include the prev adjacent element', function() {
        return expect(this.multi.moveToPrev()).toSelect(this.list, 1, 2);
      });
      return it('does not wrap around to the top of the list', function() {
        this.multi = new this.MultiSelect(this.list);
        this.multi.selectNext();
        return expect(this.multi.moveToPrev()).toSelect(this.list, 0);
      });
    });
    return describe('moveToNext', function() {
      it('expands the selection to include the next adjacent element', function() {
        this.multi.moveToNext();
        return expect(this.multi.selected).toSelect(this.list, 2, 3);
      });
      return it('does not wrap around to the bottom of the list', function() {
        this.multi.reset(_.last(this.list));
        this.multi.moveToNext();
        return expect(this.multi.selected).toSelect(this.list, 6);
      });
    });
  });

}).call(this);

(function() {
  describe('expressionUtils', function() {
    beforeEach(module('akop-query-filter'));
    beforeEach(inject([
      'expressionUtils', function(utils) {
        this.utils = utils;
      }
    ]));
    describe('getArrayArguments', function() {
      return it('returns the arguments as an array of objects with attr and arg values', function() {
        var exp;
        exp = {
          a: 1,
          b: [1, 2, 3],
          c: "hello"
        };
        return expect(this.utils.getArrayArguments(exp)).toEqual([
          {
            attr: 'b',
            arg: [1, 2, 3]
          }
        ]);
      });
    });
    return describe('arrayArgsToExpressions', function() {
      return it('creates an expression for each value in an array argument', function() {
        var exp;
        exp = {
          a: 1,
          b: [1, 2, 3],
          c: "hello"
        };
        return expect(this.utils.arrayArgsToExpressions(exp)).toEqual([
          {
            b: 1
          }, {
            b: 2
          }, {
            b: 3
          }
        ]);
      });
    });
  });

}).call(this);

(function() {
  describe('QueryFilter', function() {
    beforeEach(module('akop-query-filter', function() {}));
    beforeEach(inject(function($filter) {
      this.filter = $filter('akopQuery');
      return this.list = [
        {
          id: 1,
          name: 'Workit',
          fk_id: 1
        }, {
          id: 2,
          name: 'Fandroo',
          fk_id: 1
        }, {
          id: 3,
          name: 'Lendry',
          fk_id: 2
        }, {
          id: 4,
          name: 'Workit',
          fk_id: 2
        }, {
          id: 5,
          name: 'Hypstr',
          fk_id: 2
        }, {
          id: 6,
          name: 'Toosly',
          fk_id: 3
        }
      ];
    }));
    describe('with no arguments', function() {
      return it('returns the whole list', function() {
        return expect(this.filter(this.list, {})).toEqual(this.list);
      });
    });
    describe('when querying on an attribute', function() {
      beforeEach(function() {
        return this.filtered = this.filter(this.list, {
          fk_id: 1
        });
      });
      it('returns all matching list items', function() {
        return expect(this.filtered.length).toBe(2);
      });
      return it('returns only matching list items', function() {
        var result, _i, _len, _ref, _results;
        _ref = this.filtered;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          result = _ref[_i];
          _results.push(expect(result.fk_id).toBe(1));
        }
        return _results;
      });
    });
    describe('when querying by multiple attrs', function() {
      beforeEach(function() {
        return this.filtered = this.filter(this.list, {
          name: 'Workit',
          fk_id: 1
        });
      });
      it('returns all matching list items', function() {
        return expect(this.filtered.length).toBe(1);
      });
      return it('returns only matching list items', function() {
        return expect(this.filtered[0]).toEqual(this.list[0]);
      });
    });
    describe('when expression includes a group_by attribute', function() {
      describe('and the list has the given attribute', function() {
        beforeEach(function() {
          return this.filtered = this.filter(this.list, {
            group_by: 'name'
          });
        });
        it('has top level keys for the given group_by attr', function() {
          var key, keys, val;
          keys = (function() {
            var _ref, _results;
            _ref = this.filtered;
            _results = [];
            for (key in _ref) {
              val = _ref[key];
              _results.push(key);
            }
            return _results;
          }).call(this);
          return expect(keys).toEqual(['Workit', 'Fandroo', 'Lendry', 'Hypstr', 'Toosly']);
        });
        return it('has matching list members', function() {
          return expect(this.filtered['Workit']).toEqual([this.list[0], this.list[3]]);
        });
      });
      return describe('and the list members do not have the given attribute', function() {
        return it('throws an error', function() {
          return expect((function(_this) {
            return function() {
              return _this.filter(_this.list, {
                group_by: 'xyz'
              });
            };
          })(this)).toThrow(new Error("serviceQueryFilter: Missing group_by property \"xyz\" for some or all elements in list."));
        });
      });
    });
    describe("when expression includes multiple values for a given attribute", function() {
      return it('returns all matching items', function() {
        var filtered;
        filtered = this.filter(this.list, {
          id: [1, 2]
        });
        expect(filtered.length).toEqual(2);
        expect(filtered.indexOf(this.list[0])).not.toBe(-1);
        return expect(filtered.indexOf(this.list[1])).not.toBe(-1);
      });
    });
    describe("when given multiple values for multiple attributes", function() {
      return it('returns all matching items', function() {
        var filtered;
        filtered = this.filter(this.list, {
          id: [1, 2],
          fk_id: [1, 2]
        });
        return expect(filtered.length).toBe(5);
      });
    });
    describe("when given multiple attributes and multiple values", function() {
      return it('returns only matching items', function() {
        var filtered;
        filtered = this.filter(this.list, {
          id: [1, 2],
          name: 'Workit'
        });
        return expect(filtered.length).toBe(1);
      });
    });
    describe("when given a string for an argument", function() {
      return it('works the same as if given an object', function() {
        var filtered;
        filtered = this.filter(this.list, "fk_id:1");
        return expect(filtered.length).toBe(2);
      });
    });
    return describe("when given an array value with no matching elements", function() {
      return it('returns an empty array', function() {
        var filtered;
        filtered = this.filter(this.list, {
          id: [7]
        });
        return expect(filtered.length).toBe(0);
      });
    });
  });

}).call(this);

(function() {
  describe('QueryParser', function() {
    beforeEach(module('akop-query-filter', function() {}));
    beforeEach(inject(function(akopParser) {
      this.akopParser = akopParser;
    }));
    describe('parse', function() {
      return describe('given an object', function() {
        return it('returns the object', function() {
          var o;
          o = {
            name: 'Jasmine'
          };
          return expect(this.akopParser(o)).toBe(o);
        });
      });
    });
    describe('given a string with no : separator', function() {
      return it('returns the string', function() {
        var exp;
        exp = 'some string';
        return expect(this.akopParser(exp)).toBe(exp);
      });
    });
    describe('given a string with : separator', function() {
      return it('returns an object', function() {
        var exp;
        exp = 'ay:bee see:dee';
        return expect(this.akopParser(exp)).toEqual({
          ay: "bee",
          see: "dee"
        });
      });
    });
    describe('given a string with an array value', function() {
      return it('returns the value as an array of string', function() {
        var exp;
        exp = 'a:[1,two]';
        return expect(this.akopParser(exp)).toEqual({
          a: ["1", "two"]
        });
      });
    });
    describe('given a quoted string', function() {
      return it('returns the value as expected', function() {
        var exp;
        exp = 'name:"Joe Blow"';
        return expect(this.akopParser(exp)).toEqual({
          name: "Joe Blow"
        });
      });
    });
    return describe('given a quoted string in an array value', function() {
      return it('returns the value as expected', function() {
        var exp;
        exp = 'a:[1,two,"three times three"]';
        return expect(this.akopParser(exp)).toEqual({
          a: ["1", "two", "three times three"]
        });
      });
    });
  });

}).call(this);
