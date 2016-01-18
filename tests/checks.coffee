describe "VmChecks", ->

  beforeEach ->
    @errorStub = sinon.stub console, 'error'

  afterEach ->
    sinon.restoreAll()

  describe "T#viewmodelArgs", ->

    beforeEach ->
      @template =
        viewName: 'A'

    it "should accept an object", ->
      VmCheck "T#viewmodelArgs", @template, [{}]
      assert.isFalse @errorStub.called

    it "should accept a function", ->
      VmCheck "T#viewmodelArgs", @template, [(->)]
      assert.isFalse @errorStub.called

    it "rejects an empty array", ->
      VmCheck "T#viewmodelArgs", @template, []
      assert.isTrue @errorStub.called

    it "rejects a number", ->
      VmCheck "T#viewmodelArgs", @template, [1]
      assert.isTrue @errorStub.called

    it "rejects a string", ->
      VmCheck "T#viewmodelArgs", @template, ["1"]
      assert.isTrue @errorStub.called

    it "rejects two objects", ->
      VmCheck "T#viewmodelArgs", @template, [{},{}]
      assert.isTrue @errorStub.called



  describe "T#viewmodel", ->

    beforeEach ->
      @template =
        viewName: 'A'

    it "should accept an object", ->
      VmCheck "T#viewmodel", {}, @template
      assert.isFalse @errorStub.called

    it "should accept a function", ->
      VmCheck "T#viewmodel", (->), @template
      assert.isFalse @errorStub.called

    it "should not accept a number", ->
      VmCheck "T#viewmodel", 1, @template
      assert.isTrue @errorStub.called
      return

    it "should not accept a string", ->
      VmCheck "T#viewmodel", "", @template
      assert.isTrue @errorStub.called

    describe "events", ->

      it "accepts object with String: Function", ->
        initial =
          events:
            a: ->
            b: ->
        VmCheck "T#viewmodel", initial, @template
        assert.isFalse @errorStub.called

      it "rejects object with String: number", ->
        initial =
          events:
            a: ->
            b: 1
        VmCheck "T#viewmodel", initial, @template
        assert.isTrue @errorStub.called

      it "rejects number", ->
        initial =
          events: 1
        VmCheck "T#viewmodel", initial, @template
        assert.isTrue @errorStub.called

      it "rejects function", ->
        initial =
          events: ->
        VmCheck "T#viewmodel", initial, @template
        assert.isTrue @errorStub.called

      it "rejects array", ->
        initial =
          events: []
        VmCheck "T#viewmodel", initial, @template
        assert.isTrue @errorStub.called


  describe "@addBinding", ->

    it "should not accept a string", ->
      VmCheck "@addBinding", ""
      assert.isTrue @errorStub.called

    it "should not accept an object without a name string", ->
      VmCheck "@addBinding", { name: 1 }
      assert.isTrue @errorStub.called

    it "should not accept an object without an empty name", ->
      VmCheck "@addBinding", { name: " ", bind: (->) }
      assert.isTrue @errorStub.called

    it "should not accept an object without a bind, events, or autorun", ->
      VmCheck "@addBinding", { name: "value" }
      assert.isTrue @errorStub.called

    it "should not accept an object without a bind function", ->
      VmCheck "@addBinding", { name: "value", bind: 1 }
      assert.isTrue @errorStub.called

    it "should accept an object with a name and a bind function", ->
      VmCheck "@addBinding", { name: "value", bind: (->) }
      assert.isFalse @errorStub.called

    it "bindIf has to be a function", ->
      VmCheck "@addBinding", { name: "value", bindIf: 1 }
      assert.isTrue @errorStub.called

    it "selector has to be a string", ->
      VmCheck "@addBinding", { name: "value",  selector: 1 }
      assert.isTrue @errorStub.called

    it "events has to be an object", ->
      VmCheck "@addBinding", { name: "value", events: 1 }
      assert.isTrue @errorStub.called

    it "autorun has to be a function", ->
      VmCheck "@addBinding", { name: "value", autorun: 1 }
      assert.isTrue @errorStub.called

    it "priority has to be a number", ->
      VmCheck "@addBinding", { name: "value", bind: (->), priority: 'A' }
      assert.isTrue @errorStub.called

  describe "getBindHelper", ->
    it "accepts a view model", ->
      templateInstance =
        view:
          name: 'A'
        viewmodel: {}

      VmCheck "getBindHelper", templateInstance

    it "throws without a view model", ->
      templateInstance =
        view:
          name: 'A'
      VmCheck "getBindHelper", templateInstance
      assert.isTrue @errorStub.called

  describe "T#createViewModel", ->
    beforeEach ->
      @template =
        viewName: 'A'
    it "doesn't check undefined contexts", ->
      VmCheck 'T#createViewModel', undefined , @template
      assert.isFalse @errorStub.called

    it "rejects a function for context", ->
      VmCheck 'T#createViewModel', (->) , @template
      assert.isTrue @errorStub.called


  describe "#parent", ->

    it "should accept no arguments", ->
      VmCheck "#parent"
      assert.isFalse @errorStub.called

    it "should not accept arguments", ->
      VmCheck "#parent", 'X'
      assert.isTrue @errorStub.called

  describe "#children", ->

    it "should accept no arguments", ->
      VmCheck "#children"
      assert.isFalse @errorStub.called

    it "should accept a string", ->
      VmCheck "#children", 'X'
      assert.isFalse @errorStub.called

    it "should accept a function", ->
      VmCheck "#children", ->
      assert.isFalse @errorStub.called

    it "should not accept a number", ->
      VmCheck "#children", 1
      assert.isTrue @errorStub.called

    it "should not accept an object", ->
      VmCheck "#children", 1
      assert.isTrue @errorStub.called

  describe "@onRendered", ->

    it "should accept undefined autorun", ->
      VmCheck "@onRendered", undefined
      assert.isFalse @errorStub.called

    it "should accept autorun function ", ->
      VmCheck "@onRendered", ->
      assert.isFalse @errorStub.called

    it "should accept array of autorun functions ", ->
      VmCheck "@onRendered", [ (->) ]
      assert.isFalse @errorStub.called

    it "should not accept autorun string", ->
      VmCheck "@onRendered", "X", { viewName: 'body' }
      assert.isTrue @errorStub.called

    it "should not accept autorun object", ->
      VmCheck "@onRendered", "X", { viewName: 'body' }
      assert.isTrue @errorStub.called

    it "should not accept array of autorun strings", ->
      VmCheck "@onRendered", [ '' ], { viewName: 'body' }
      assert.isTrue @errorStub.called

    it "should not accept array of autorun objects", ->
      VmCheck "@onRendered", [ {} ], { viewName: 'body' }
      assert.isTrue @errorStub.called

    it "should not accept array without functions", ->
      VmCheck "@onRendered", [ (->), 0, (->) ], { viewName: 'body' }
      assert.isTrue @errorStub.called

  describe "#constructor", ->

    describe "persist", ->
      it "accepts boolean", ->
        VmCheck "#constructor", { persist: true }
        assert.isFalse @errorStub.called
      it "accepts function", ->
        VmCheck "#constructor", { persist: -> }
        assert.isFalse @errorStub.called
      it "rejects string", ->
        VmCheck "#constructor", { persist: 'true' }
        assert.isTrue @errorStub.called
      it "rejects number", ->
        VmCheck "#constructor", { persist: 0 }
        assert.isTrue @errorStub.called
      it "rejects object", ->
        VmCheck "#constructor", { persist: {} }
        assert.isTrue @errorStub.called

  describe "$default", ->
    it "accepts input", ->
      VmCheck '$default', { bindName: 'input' }
      assert.isFalse @errorStub.called

    it "rejects XAXA", ->
      bindArg =
        bindName: 'XAXA'
        templateInstance:
          view:
            name: 'Template.A'
      VmCheck '$default', bindArg
      assert.isTrue @errorStub.called

  describe "@saveUrl", ->
    it "accepts vm without _id and vmTag", ->
      vm = {}
      VmCheck '@saveUrl', vm
      assert.isFalse @errorStub.called

    it "accepts vm with _id and vmTag", ->
      vm =
        _id: ->
        vmTag: ->
      VmCheck '@saveUrl', vm
      assert.isFalse @errorStub.called

    it "accepts vm with vmTag", ->
      vm =
        vmTag: ->
      VmCheck '@saveUrl', vm
      assert.isFalse @errorStub.called

    it "doesn't accept vm with _id", ->
      vm =
        _id: ->
        templateInstance:
          view:
            name: 'Template.A'
      VmCheck '@saveUrl', vm
      assert.isTrue @errorStub.called
