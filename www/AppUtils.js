var exec = require('cordova/exec');
/**
 * Constructor
 */
function AppUtils() {}

AppUtils.prototype.getAppVersion = function(response) {
    exec(response, null, "AppUtils", "getAppVersion", []);
};
AppUtils.prototype.getBundleId = function(response) {
    exec(response, null, "AppUtils", "getBundleId", []);
};

AppUtils.prototype.sendToApp = function(appStoreUrl, appUri) {
    exec(null, null, "AppUtils", "sendToApp", [appStoreUrl, appUri]);
};

var AppUtils = new AppUtils();
module.exports = AppUtils