var exec = require('cordova/exec');
/**
 * Constructor
 */
function RecordVideoAndUploadS3() {}

RecordVideoAndUploadS3.prototype.open = function(callback, errorCallback) {
  exec(callback, errorCallback, "RecordVideoAndUploadS3", "open", []);
}

var myPlugin = new RecordVideoAndUploadS3();
module.exports = myPlugin