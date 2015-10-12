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
      VmCheck "@addBinding", { name: "value", bind: (->), bindIf: 1 }
      assert.isTrue @errorStub.called

    it "selector has to be a string", ->
      VmCheck "@addBinding", { name: "value", bind: (->), selector: 1 }
      assert.isTrue @errorStub.called

    it "events has to be an object", ->
      VmCheck "@addBinding", { name: "value", bind: (->), events: 1 }
      assert.isTrue @errorStub.called

    it "autorun has to be a function", ->
      VmCheck "@addBinding", { name: "value", bind: (->), autorun: 1 }
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

  describe "T#onRendered", ->

    it "accepts firstNode == lastNode", ->
      templateInstance =
        view:
          name: 'A'
        firstNode: 1
        lastNode: 1
      VmCheck 'T#onRendered', templateInstance
      assert.isFalse @errorStub.called

    it "rejects firstNode != lastNode", ->
      templateInstance =
        view:
          name: 'A'
        firstNode: 1
        lastNode: 2
      VmCheck 'T#onRendered', templateInstance
      assert.isTrue @errorStub.called

    it "rejects if parent's firstNode != lastNode", ->
      templateInstance =
        view:
          name: 'Template.A'
          parentView:
            name: 'Template.B'
            templateInstance: ->
              view:
                name: 'Template.B'
              firstNode: 1
              lastNode: 2
        firstNode: 1
        lastNode: 1
      VmCheck 'T#onRendered', templateInstance
      assert.isTrue @errorStub.called

    it "doesn't check for 'body'", ->
      templateInstance =
        view:
          name: 'body'
        firstNode: 1
        lastNode: 2
      VmCheck 'T#onRendered', templateInstance
      assert.isFalse @errorStub.called

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