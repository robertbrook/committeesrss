[![Build Status](https://travis-ci.org/phated/gulp-toc.png?branch=master)](https://travis-ci.org/phated/gulp-toc)

## Information

<table>
<tr>
<td>Package</td><td>gulp-toc</td>
</tr>
<tr>
<td>Description</td>
<td>Generate a Table of Contents for HTML files</td>
</tr>
<tr>
<td>Node Version</td>
<td>≥ 0.10</td>
</tr>
</table>

## Usage

Generate a Table of Contents

```javascript
var toc = require('gulp-toc');

gulp.task('toc', function() {
  gulp.src('./*.html')
    .pipe(toc())
    .pipe(gulp.dest('./dist/'))
});
```

## Options

All options supported by [node-toc](https://github.com/cowboy/node-toc) are supported.

## Header

By default, node-toc uses `<!-- toc -->` as the placeholder for the generated table of contents.

You can use `gulp-header` to insert the placeholder into all your files.

```javascript
var toc = require('gulp-toc');
var header = require('gulp-header');

gulp.task('toc', function() {
  gulp.src('./*.html')
    .pipe(header('<!-- toc -->\n'))
    .pipe(toc())
    .pipe(gulp.dest('./dist/'))
});
```

## LICENSE

(MIT License)

Copyright (c) 2014 Blaine Bublitz

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
