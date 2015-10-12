describe "VmChecks", ->
  describe "T#viewmodel", ->
    it "should accept an object", ->
      VmCheck "T#viewmodel", {}

    it "should accept a function", ->
      VmCheck "T#viewmodel", (->)

    it "should not accept a number", ->
      assert.throws ->
        VmCheck "T#viewmodel", 1
        return

    it "should not accept a string", ->
      assert.throws ->
        VmCheck "T#viewmodel", ""

    it "should not accept zero parameters", ->
      assert.throws ->
        VmCheck "T#viewmodel"


  describe "@addBinding", ->
    it "should not accept a string", ->
      assert.throws ->
        VmCheck "@addBinding", ""
    it "should not accept zero parameters", ->
      assert.throws ->
        VmCheck "@addBinding"
    it "should not accept an object without a name string", ->
      assert.throws ->
        VmCheck "@addBinding", { name: 1 }
    it "should not accept an object without an empty name", ->
      assert.throws ->
        VmCheck "@addBinding", { name: " ", bind: (->) }
    it "should not accept an object without a bind, events, or autorun", ->
      assert.throws ->
        VmCheck "@addBinding", { name: "value" }
    it "should not accept an object without a bind function", ->
      assert.throws ->
        VmCheck "@addBinding", { name: "value", bind: 1 }

    it "should accept an object with a name and a bind function", ->
      VmCheck "@addBinding", { name: "value", bind: (->) }

    it "should not accept multiple parameters", ->
      assert.throws ->
        VmCheck "@addBinding", { name: "value", bind: (->) }, { name: "value", bind: (->) }

    it "bindIf has to be a function", ->
      assert.throws ->
        VmCheck "@addBinding", { name: "value", bind: (->), bindIf: 1 }

    it "selector has to be a string", ->
      assert.throws ->
        VmCheck "@addBinding", { name: "value", bind: (->), selector: 1 }

    it "events has to be an object", ->
      assert.throws ->
        VmCheck "@addBinding", { name: "value", bind: (->), events: 1 }

    it "autorun has to be a function", ->
      assert.throws ->
        VmCheck "@addBinding", { name: "value", bind: (->), autorun: 1 }

  describe "getBindHelper", ->
    it "accepts a view model", ->
      templateInstance =
        view:
          name: 'A'
        viewmodel: {}

      VmCheck "getBindHelper", templateInstance

    it "throws without a view model", ->
      assert.throws ->
        templateInstance =
          view:
            name: 'A'
        VmCheck "getBindHelper", templateInstance

