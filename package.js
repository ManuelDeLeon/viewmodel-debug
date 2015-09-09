Package.describe({
  name: 'manuel:viewmodel-debug',
  summary: "Debug information for the ViewModel package.",
  version: "2.0.0",
  git: "https://github.com/ManuelDeLeon/viewmodel-debug",
  debugOnly: true
});

var CLIENT = 'client';

Package.onUse(function(api) {
  api.use([
    'coffeescript'
  ], CLIENT);

  api.addFiles([
    'lib/viewmodel-checks.coffee'
  ], CLIENT);

  api.export('VmCheck', CLIENT);

});

Package.onTest(function(api) {
  api.use([
    'coffeescript',
    'peterellisjones:describe'
  ], CLIENT);

  api.addFiles([
    'lib/viewmodel-checks.coffee',
    'tests/addBinding.coffee'
  ], CLIENT);

  api.export('VmCheck', CLIENT);

});