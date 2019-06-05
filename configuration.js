var configuration = require('./configuration.json');

var configurationLocal = {};

try {
    configurationLocal = require('./configuration.local.json');
} catch{
}

Object.keys(configurationLocal).map(it => configuration[it] = configurationLocal[it]);

exports.configuration = configuration;