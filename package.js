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
    'coffeescript@1.0.10',
    'underscore@1.0.4'
  ], CLIENT);

  api.addFiles([
    'lib/viewmodel-checks.coffee'
  ], CLIENT);

  api.export('VmCheck', CLIENT);

});

Package.onTest(function(api) {
  api.use([
    'coffeescript@1.0.10',
    'underscore@1.0.4',
    'practicalmeteor:mocha',
    'practicalmeteor:sinon'
  ], CLIENT);

  api.addFiles([
    'lib/viewmodel-checks.coffee',
    'tests/sinon-restore.js',
    'tests/checks.coffee'
  ], CLIENT);

  api.export('VmCheck', CLIENT);

});