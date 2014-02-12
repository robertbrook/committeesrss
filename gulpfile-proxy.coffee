gulp      = require "gulp"
clean     = require "gulp-clean"
gutil     = require "gulp-util"
docco     = require "gulp-docco"
html2md   = require "gulp-html2md"
getter    = require "./getter"
cheerio   = require "gulp-cheerio"
lazy      = require "lazy"

#https://www.npmjs.org/package/gulp-rss/
#Currently, gulp-cheerio uses cheerio ~0.13.0.

loggit = (text) ->
  console.log (text)

paths =
  data: "data/*"
  output:"output/*"

gulp.task "default", ->
  loggit "ok"
  
gulp.task "sync", ->
  gulp.src([ "./data/*" ]).pipe(cheerio(run: ($) ->
    $("title").each ->
      h1 = $(this)
      h1.text h1.text().toUpperCase()

  ))
  .pipe gulp.dest("./output")


gulp.task "mdit", ->  
  gulp.src([ "./data/10*" ])
    .pipe html2md()
    .pipe gulp.dest("./output")
    
gulp.task "clean", ->
  gulp.src(paths.output,
    read: false
  ).pipe clean()

gulp.task "docco", ->
  gulp.src("*.coffee")
  .pipe(docco())
  .pipe gulp.dest("./docs")
