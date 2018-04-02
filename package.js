Package.describe({
  name: 'manuel:viewmodel-debug',
  summary: "Debug information for the ViewModel package.",
  version: "2.7.2",
  git: "https://github.com/ManuelDeLeon/viewmodel-debug",
  debugOnly: true
});

var CLIENT = 'client';

Package.onUse(function(api) {
  api.use([
    'coffeescript@2.0.3_4',
    'underscore@1.0.3'
  ], CLIENT);

  api.addFiles([
    'lib/viewmodel-checks.coffee'
  ], CLIENT);

  api.export('VmCheck', CLIENT);

});

Package.onTest(function(api) {
  api.use([
    'coffeescript@2.0.3_4',
    'underscore@1.0.3',
    'practicalmeteor:mocha',
    'practicalmeteor:sinon',
    'practicalmeteor:chai'
  ], CLIENT);

  api.addFiles([
    'lib/viewmodel-checks.coffee',
    'tests/sinon-restore.js',
    'tests/checks.coffee'
  ], CLIENT);

  api.export('VmCheck', CLIENT);

});