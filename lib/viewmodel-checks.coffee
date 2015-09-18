ref = (tag) -> " See https://viewmodel.org/docs/#{tag} for more information."

checks =
  '@@addBinding': (args...) ->
    tag = 'bindings#bindingObject'

    if args.length is 0
      throw new Error "ViewModel.addBinding requires an object." + ref tag
    if args.length isnt 1
      throw new Error "ViewModel.addBinding only takes one object." + ref tag

    binding = args[0]

    if not _.isObject binding
      throw new Error "ViewModel.addBinding requires an object." + ref tag

    if (not _.isString binding.name) or binding.name.trim() is ""
      throw new Error "ViewModel.addBinding requires an object with a name (string)." + ref tag

    if not _.isFunction binding.bind
      throw new Error "ViewModel.addBinding requires an object with a bind function." + ref tag

    if binding.bindIf and not _.isFunction binding.bindIf
      throw new Error "Optional property 'bindIf' has to be a function when passed to ViewModel.addBinding." + ref tag

    if binding.selector and not _.isString binding.bindIf
      throw new Error "Optional property 'selector' has to be a string when passed to ViewModel.addBinding." + ref tag

    if binding.events and not _.isObject binding.events
      throw new Error "Optional property 'events' has to be an object when passed to ViewModel.addBinding." + ref tag

    if binding.autorun and not _.isFunction binding.autorun
      throw new Error "Optional property 'autorun' has to be a function when passed to ViewModel.addBinding." + ref tag

    return

  'T@viewmodel': (args...) ->
    tag = 'creating'

    if args.length is 0
      throw new Error "Creating a view model requires an object or a function that returns an object." + ref tag
    if args.length isnt 1
      throw new Error "Creating a view model only takes one object." + ref tag

    initial = args[0]

    if not (_.isObject(initial) or _.isFunction(initial))
      throw new Error "Creating a view model requires an object or a function that returns an object." + ref tag

VmCheck = (key, args...) ->
  if checks[key]
    checks[key] args...
  else
    throw new Error "Don't have debug information for [#{key}]. Please report it on https://viewmodel.org/help. In the mean time you can turn off checks with `ViewModel.ignoreErrors = true`." + ref 'staticMethods#ignoreErrors'
  return
