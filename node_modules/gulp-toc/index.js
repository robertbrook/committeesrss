'use strict';

var through = require('through2');
var toc = require('toc');
var PluginError = require('gulp-util').PluginError;

module.exports = function(options){
  var opts = options || {};

  function GenerateTOC(file, enc, cb){
    if(file.isStream()){
      this.emit('error', new PluginError('gulp-toc', 'Streaming not supported'));
      return cb();
    }

    if(file.isBuffer()){
      file.contents = new Buffer(toc.process(String(file.contents), opts));
    }

    this.push(file);
    cb();
  }

  return through.obj(GenerateTOC);
};
