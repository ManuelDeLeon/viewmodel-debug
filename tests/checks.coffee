describe "VmChecks", ->
  context "T@viewmodel", ->
    it "should accept an object", ->
      VmCheck "T@viewmodel", {}

    it "should accept a function", ->
      VmCheck "T@viewmodel", (->)

    it "should not accept a number", (t) ->
      t.throws ->
        VmCheck "T@viewmodel", 1

    it "should not accept a string", (t) ->
      t.throws ->
        VmCheck "T@viewmodel", ""

    it "should not accept zero parameters", (t) ->
      t.throws ->
        VmCheck "T@viewmodel"

    it "should not accept multiple parameters", (t) ->
      t.throws ->
        VmCheck "T@viewmodel", {}, {}

  context "@@addBinding", ->
    it "should not accept a string", (t) ->
      t.throws ->
        VmCheck "@@addBinding", ""
    it "should not accept zero parameters", (t) ->
      t.throws ->
        VmCheck "@@addBinding"
    it "should not accept an object without a name string", (t) ->
      t.throws ->
        VmCheck "@@addBinding", { name: 1 }
    it "should not accept an object without an empty name", (t) ->
      t.throws ->
        VmCheck "@@addBinding", { name: " ", bind: (->) }
    it "should not accept an object without a bind function 1", (t) ->
      t.throws ->
        VmCheck "@@addBinding", { name: "value" }
    it "should not accept an object without a bind function 2", (t) ->
      t.throws ->
        VmCheck "@@addBinding", { name: "value", bind: 1 }

    it "should accept an object with a name and a bind function", (t) ->
      VmCheck "@@addBinding", { name: "value", bind: (->) }

    it "should not accept multiple parameters", (t) ->
      t.throws ->
        VmCheck "@@addBinding", { name: "value", bind: (->) }, { name: "value", bind: (->) }

    it "bindIf has to be a function", (t) ->
      t.throws ->
        VmCheck "@@addBinding", { name: "value", bind: (->), bindIf: 1 }

    it "selector has to be a string", (t) ->
      t.throws ->
        VmCheck "@@addBinding", { name: "value", bind: (->), selector: 1 }

    it "events has to be an object", (t) ->
      t.throws ->
        VmCheck "@@addBinding", { name: "value", bind: (->), events: 1 }

    it "autorun has to be a function", (t) ->
      t.throws ->
        VmCheck "@@addBinding", { name: "value", bind: (->), autorun: 1 }