var exec = require('cordova/exec');
/**
 * Constructor
 */

function SharePlugin() { }

//show Share Sheet with an url
SharePlugin.prototype.show = function(success, failure, options) {
    options = options || {};
    exec(success, failure, 'SharePlugin', 'show', [options]);
};

module.exports = new SharePlugin();