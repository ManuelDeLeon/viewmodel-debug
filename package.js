Package.describe({
  name: 'manuel:viewmodel-debug',
  summary: "Debug information for the ViewModel package.",
  version: "2.0.0",
  git: "https://github.com/ManuelDeLeon/viewmodel-debug",
  debugOnly: false
});

var CLIENT = 'client';

Package.onUse(function(api) {
  api.use([
    'coffeescript'
  ], CLIENT);

  api.addFiles([
    'lib/viewmodel-debug.coffee'
  ], CLIENT);

  api.export('VmCheck', CLIENT);

});

Package.onTest(function(api) {
  api.use([
    'coffeescript'
  ], CLIENT);

  api.addFiles([
    'lib/viewmodel-debug.coffee'
  ], CLIENT);

  api.export('VmCheck', CLIENT);

});