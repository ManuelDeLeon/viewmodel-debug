ref = (tag) -> " See https://viewmodel.org/docs/#{tag} for more information."

checks =
  '@addBinding': (binding) ->
    tag = 'bindings#bindingObject'

    if arguments.length is 0
      throw new Error "ViewModel.addBinding requires an object." + ref tag
    if arguments.length isnt 1
      throw new Error "ViewModel.addBinding only takes one object." + ref tag

    if not _.isObject binding
      throw new Error "ViewModel.addBinding requires an object." + ref tag

    if (not _.isString binding.name) or binding.name.trim() is ""
      throw new Error "ViewModel.addBinding requires an object with a name (string)." + ref tag

    if binding.bind and not _.isFunction binding.bind
      throw new Error "Optional property 'bind' has to be a function when passed to ViewModel.addBinding." + ref tag

    if binding.bindIf and not _.isFunction binding.bindIf
      throw new Error "Optional property 'bindIf' has to be a function when passed to ViewModel.addBinding." + ref tag

    if binding.selector and not _.isString binding.bindIf
      throw new Error "Optional property 'selector' has to be a string when passed to ViewModel.addBinding." + ref tag

    if binding.events and not _.isObject binding.events
      throw new Error "Optional property 'events' has to be an object when passed to ViewModel.addBinding." + ref tag

    if binding.autorun and not _.isFunction binding.autorun
      throw new Error "Optional property 'autorun' has to be a function when passed to ViewModel.addBinding." + ref tag

    if not ( binding.bind or binding.events or binding.autorun )
      throw new Error "ViewModel.addBinding requires at least one of: bind, events, autorun." + ref tag

    return

  'T#viewmodel': (initial, template) ->
    tag = 'viewmodels#defining'

    name = template.viewName.substr(template.viewName.indexOf('.') + 1)

    if not (_.isObject(initial) or _.isFunction(initial))
      throw new Error "Could not create the view model for template '#{name}'. Creating a view model requires an object or a function that returns an object." + ref tag

    return

  'getBindHelper': (templateInstance) ->
    tag = 'viewmodels#defining'
    name = templateInstance.view.name.substr(templateInstance.view.name.indexOf('.') + 1)
    if not templateInstance.viewmodel
      throw new Error "The template '#{name}' doesn't have a view model associated with it." + ref tag
    return

VmCheck = (key, args...) ->
  if checks[key]
    checks[key] args...
  else
    console.warn "Don't have debug information for [#{key}]. Please report it at https://viewmodel.org/help. In the mean time you can turn off checks with `ViewModel.ignoreErrors = true`." + ref 'staticMethods#ignoreErrors'
  return
