describe "VmChecks", ->

  beforeEach ->
    @errorStub = sinon.stub console, 'error'

  afterEach ->
    sinon.restoreAll()

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

  describe "vmProp", ->

    beforeEach ->
      @viewmodel =
        templateInstance:
          view:
            name: 'Template.A'

    it "errors when view model doesn't have property", ->
      VmCheck 'vmProp', 'name', @viewmodel
      assert.isTrue @errorStub.called

    it "accepts when view model has property", ->
      @viewmodel.name = ->
      VmCheck 'vmProp', 'name', @viewmodel
      assert.isFalse @errorStub.called
      return

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
      VmCheck "@onRendered", "X"
      assert.isTrue @errorStub.called

    it "should not accept autorun object", ->
      VmCheck "@onRendered", "X"
      assert.isTrue @errorStub.called

    it "should accept array of autorun strings", ->
      VmCheck "@onRendered", [ '' ]
      assert.isTrue @errorStub.called

    it "should accept array of autorun objects", ->
      VmCheck "@onRendered", [ {} ]
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
