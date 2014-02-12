'use strict';

var test = require('tap').test;

var gulp = require('gulp');
var task = require('../');
var path = require('path');

var filename = path.join(__dirname, './fixtures/helloworld.html');

test('should generate a table of contents for HTML files', function(t){
  var result = task();

  result.on('data', function(file){
    t.equal(String(file.contents), '<div class="toc"><ul><li><a href="#hello-world">Hello World</a></li></ul></div>\n<h2><a href="#hello-world" name="hello-world">Hello World</a></h2>\n');
    t.end();
  });

  gulp.src(filename).pipe(result);
});
