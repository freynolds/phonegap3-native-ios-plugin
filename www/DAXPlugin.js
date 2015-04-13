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
// category = The event category. This parameter is required to be non-empty.
// eventAction = The event action. This parameter is required to be non-empty.
// eventLabel = The event label. This parameter may be a blank string to indicate no label.
// eventValue = The event value. This parameter may be -1 to indicate no value.
DaxPlugin.prototype.trackEvent = function(success, fail, eventLabel, eventValue) {
    exec(success, fail, 'DaxPlugin', 'trackEvent', [eventLabel, eventValue]);
};


// log a page view
//
// pageURL = the URL of the page view
DaxPlugin.prototype.trackPage = function(success, fail, pageURL) {
    exec(success, fail, 'DaxPlugin', 'trackPage', [pageURL]);
};

DaxPlugin.prototype.exit = function(success, fail) {
    exec(success, fail, 'DaxPlugin', 'exitDAX', []);
};


var DaxPlugin = new DaxPlugin();
module.exports = DaxPlugin