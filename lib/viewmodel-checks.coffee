ref = (tag) -> " See https://viewmodel.org/docs/#{tag} for more information."
isObject = (obj) -> _.isObject(obj) and !_.isArray(obj) and !_.isFunction(obj)
templateName = (str) -> str.substr(str.indexOf('.') + 1)

parentTemplate = (templateInstance) ->
  view = templateInstance.view?.parentView
  while view
    if view.name.substring(0, 9) == 'Template.'
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

    return

  'T#viewmodel': (initial, template) ->
    tag = 'viewmodels#defining'

    if not (isObject(initial) or _.isFunction(initial))
      name = template.viewName.substr(template.viewName.indexOf('.') + 1)
      console.error "Could not create the view model for template '#{name}'. Creating a view model requires an object or a function that returns an object." + ref tag

    return

  'getBindHelper': (templateInstance) ->
    tag = 'viewmodels#defining'
    if not templateInstance.viewmodel
      name = templateName(templateInstance.view.name)
      console.error "The template '#{name}' doesn't have a view model associated with it. No `Template.#{name}.viewmodel` found in the code." + ref tag

    return

  'T#createViewModel': (context, template) ->
    tag = 'testing#createViewModel'
    if context and !isObject(context)
      name = template.viewName.substr(template.viewName.indexOf('.') + 1)
      console.error "Could not create the view model for template '#{name}'. If you pass a context to `Template.#{name}.createViewModel` it must be an object." + ref tag

    return

  'vmProp': (prop, viewmodel, type = 'property') ->
    tag = 'viewmodels#defining'
    if not viewmodel[prop]
      name = templateName(viewmodel.templateInstance.view.name)
      console.error "The view model for template '#{name}' doesn't have a '#{prop}' #{type}." + ref tag


VmCheck = (key, args...) ->
  if checks[key]
    checks[key] args...
  else
    console.warn "Don't have debug information for [#{key}]. Please report it at https://viewmodel.org/help. In the mean time you can turn off checks with `ViewModel.ignoreErrors = true`." + ref 'staticMethods#ignoreErrors'
  return
