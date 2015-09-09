
checks =
  '@@addBinding': (args...) ->
    binding = args[0]
    if not _.isObject binding
      throw new Error "ViewModel.addBinding requires an object. See https://viewmodel.org/docs/bindings#bindingObject for more information."

    if (not _.isString binding.name) or binding.name.trim() is ""
      throw new Error "ViewModel.addBinding requires an object with a name (string). See https://viewmodel.org/docs/bindings#bindingObject for more information."

    if not _.isFunction binding.bind
      throw new Error "ViewModel.addBinding requires an object with a bind function. See https://viewmodel.org/docs/bindings#bindingObject for more information."

    if binding.bindIf and not _.isFunction binding.bindIf
      throw new Error "Optional property 'bindIf' has to be a function when passed to ViewModel.addBinding. See https://viewmodel.org/docs/bindings#bindingObject for more information."

    if binding.selector and not _.isString binding.bindIf
      throw new Error "Optional property 'selector' has to be a string when passed to ViewModel.addBinding. See https://viewmodel.org/docs/bindings#bindingObject for more information."

    if binding.events and not _.isObject binding.events
      throw new Error "Optional property 'events' has to be an object when passed to ViewModel.addBinding. See https://viewmodel.org/docs/bindings#bindingObject for more information."

    return

VmCheck = (key, args...) ->
  if checks[key]
    checks[key] args...
  else
    throw new Error "Don't have debug information for [#{key}]. Please report it on https://viewmodel.org/help. In the mean time you can turn off checks with `ViewModel.ignoreErrors = true`. See https://viewmodel.org/docs/staticMethods#ignoreErrors for more information."
  return
