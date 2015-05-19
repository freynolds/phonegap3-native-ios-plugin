var exec = require('cordova/exec');
/**
 * Constructor
 */
function RecordVideoAndUploadS3() {}

RecordVideoAndUploadS3.prototype.open = function() {
  exec(function(result){
      // result handler
      alert(result);
    },
    function(error){
      // error handler
      alert("Error" + error);
    },
    "RecordVideoAndUploadS3",
    "open",
    []
  );
}

var myPlugin = new RecordVideoAndUploadS3();
module.exports = myPlugin