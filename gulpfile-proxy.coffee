gulp      = require "gulp"
clean     = require "gulp-clean"
gutil     = require "gulp-util"
docco     = require "gulp-docco"
html2md   = require "gulp-html2md"
getter    = require "./getter"
cheerio   = require "gulp-cheerio"
_         = require "underscore"

#https://www.npmjs.org/package/gulp-rss/
#Currently, gulp-cheerio uses cheerio ~0.13.0.

loggit = (text) ->
  console.log (text)

paths =
  data: "data/*"
  output:"output/*"

gulp.task "default", ->
#  loggit "ok"
  loggit _.each(_.range(0, 7000, 500))

  
gulp.task "sync", ->
  
  gulp.src([ "./data/*" ]).pipe(cheerio(run: ($) ->
    $("title").each ->
      h1 = $(this)
      h1.text h1.text().toUpperCase()

  ))
  .pipe gulp.dest("./output")


gulp.task "mdit", -> 
  ranges = ["./data/0*", "./data/10*", "./data/20*", "./data/30*", "./data/40*", "./data/50*"] 
  gulp.src(ranges)
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
