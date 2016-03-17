ref = (tag) -> " See https://viewmodel.org/docs/#{tag} for more information."
isObject = (obj) -> _.isObject(obj) and !(obj instanceof Array) and !_.isFunction(obj)

templateName = (template) ->
  name = template.viewName or template.view.name
  if name is 'body' then name else name.substr(name.indexOf('.') + 1)

parentTemplate = (templateInstance) ->
  view = templateInstance.view?.parentView
  while view
    if view.name.substring(0, 9) is 'Template.' or view.name is 'body'
      return view.templateInstance()
    view = view.parentView
  return


checks =
  '@addBinding': (binding) ->
    tag = 'bindings#bindingObject'

    if not isObject binding
      console.error "ViewModel.addBinding requires an object." + ref tag

    if (not _.isString binding.name) or binding.name.trim() is ""
      console.error "ViewModel.addBinding requires an object with a name (string)." + ref tag

    if binding.bind and not _.isFunction binding.bind
      console.error "Optional property 'bind' has to be a function when passed to ViewModel.addBinding." + ref tag

    if binding.bindIf and not _.isFunction binding.bindIf
      console.error "Optional property 'bindIf' has to be a function when passed to ViewModel.addBinding." + ref tag

    if binding.selector and not _.isString binding.selector
      console.error "Optional property 'selector' has to be a string when passed to ViewModel.addBinding." + ref tag

    if binding.events and not isObject binding.events
      console.error "Optional property 'events' has to be an object when passed to ViewModel.addBinding." + ref tag

    if binding.autorun and not _.isFunction binding.autorun
      console.error "Optional property 'autorun' has to be a function when passed to ViewModel.addBinding." + ref tag

    if not ( binding.bind or binding.events or binding.autorun )
      console.error "ViewModel.addBinding requires at least one of: bind, events, autorun." + ref tag

    if binding.priority and not _.isNumber(binding.priority)
      console.error "Optional property 'priority' has to be a number when passed to ViewModel.addBinding." + ref tag

    return

  'T#viewmodel': (initial, template) ->
    tag = 'viewmodels#defining'

    if not (isObject(initial) or _.isFunction(initial))
      name = templateName template
      console.error "Could not create the view model for template '#{name}'. Creating a view model requires an object or a function that returns an object." + ref tag

    if initial.events
      name = templateName template
      tag = 'viewmodels#events'
      if Object.prototype.toString.call(initial.events) is '[object Object]'
        for eventName, eventFunction of initial.events when not _.isFunction(eventFunction)
          console.error "Could not add the events for template '#{name}'. The event '#{eventName}' doesn't map to a function." + ref tag
          break
      else
        console.error "Could not add the events for template '#{name}'. The events property needs an object." + ref tag
    return

  'getBindHelper': (templateInstance) ->
    tag = 'viewmodels#defining'
    if not templateInstance.viewmodel
      name = templateName templateInstance
      console.error "The template '#{name}' doesn't have a view model associated with it. No `Template.#{name}.viewmodel` found in the code." + ref tag

    return

  '#parent': (args...) ->
    tag = 'viewmodels#parent'
    if args.length
      console.error "viewmodel.parent() doesn't take any arguments. It just returns the single parent view model." + ref tag

  '#children': (args...) ->
    tag = 'viewmodels#children'
    return if args.length is 0
    if args.length > 1
      console.error "viewmodel.children only takes 1 optional parameter (a string or a function)." + ref tag
    else if not (_.isFunction(args[0]) or _.isString(args[0]))
      console.error "viewmodel.children takes an optional parameter which can be a string or a function." + ref tag

  '@onRendered': (autorun, template) ->
    tag = 'viewmodels#autorun'
    return if !autorun or _.isFunction(autorun)
    return if (autorun instanceof Array) and autorun.length and _.every(autorun, _.isFunction)
    name = templateName template
    console.error "autorun on view model for template '#{name}' has to be function or an array of functions." + ref tag

  '#constructor': (initial) ->
    tag = 'misc#hotcodepush'
    return if !initial?.persist? or _.isBoolean(initial.persist) or _.isFunction(initial.persist)
    console.error "persist has to be a boolean or a function that returns a boolean." + ref tag

  'T#viewmodelArgs': (template, args) ->
    tag = 'viewmodels#defining'

    if args.length isnt 1
      name = templateName template
      console.error "Could not create the view model for template '#{name}'. Creating a view model only requires 1 parameter (an object or a function that returns an object). You supplied #{args.length} parameters." + ref tag
    else if not (isObject(args[0]) or _.isFunction(args[0]))
      name = templateName template
      console.error "Could not create the view model for template '#{name}'. Creating a view model requires an object or a function that returns an object." + ref tag

  '@saveUrl': (viewmodel) ->
    tag = 'misc#stateonurl'
    if viewmodel._id and not viewmodel.vmTag
      name = templateName viewmodel.templateInstance
      console.error "If you're going to put '_id' on the url you must define a 'vmTag' on the view model. This is for the view model for template '#{name}'." + ref tag

VmCheck = (key, args...) ->
  if checks[key]
    checks[key] args...
  else
    console.warn "Don't have debug information for [#{key}]. Please report it at https://viewmodel.org/help. In the mean time you can turn off checks with `ViewModel.ignoreErrors = true`." + ref 'misc#ignoreErrors'
  return
