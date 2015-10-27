var exec = require('cordova/exec');
/**
 * Constructor
 */

function DaxPlugin() { }

// initialize google analytics with an account ID and the min number of seconds between posting
//
// id = the GA account ID of the form 'UA-00000000-0'
// period = the minimum interval for transmitting tracking events if any exist in the queue
DaxPlugin.prototype.init = function(success, fail) {
    exec(success, fail, 'DaxPlugin', 'initDAX', []);
};

// log an event
//

DaxPlugin.prototype.trackEvent = function(success, fail, events) {
    exec(success, fail, 'DaxPlugin', 'trackEvent', [events]);
};


// log a page view
//
DaxPlugin.prototype.trackPage = function(success, fail, data) {
    exec(success, fail, 'DaxPlugin', 'trackPage', [data]);
};

DaxPlugin.prototype.exit = function(success, fail) {
    exec(success, fail, 'DaxPlugin', 'exitDAX', []);
};


var DaxPlugin = new DaxPlugin();
module.exports = DaxPlugin