var exec = require('cordova/exec');
/**
 * Constructor
 */
var CDVVideo = {
  play: function play(video, callback, errback) {
    exec(callback, errback, 'CDVVideo', 'play', [video]);
  },
  finished: function finished(video) {
    console.log("finished playing video " + video);
  },
  show: function hide (callback) {
    exec(null, null, 'CDVVideo', 'show', []);
  },
  hide: function hide (callback) {
    exec(null, null, 'CDVVideo', 'hide', []);
  },
  destroy: function hide (callback) {
    exec(null, null, 'CDVVideo', 'destroy', []);
  }
};

module.exports = CDVVideo