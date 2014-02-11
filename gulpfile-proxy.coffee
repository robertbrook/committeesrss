gulp = require("gulp")
autoprefixer = require("gulp-autoprefixer")
uglify = require("gulp-uglify")
rename = require("gulp-rename")
clean = require("gulp-clean")
coffee = require("gulp-coffee")
gutil = require("gulp-util")
docco = require("gulp-docco")
getter = require("./getter")

paths =
  data: "data/*"
  output:"output/*"

gulp.task "default", ->
  console.log "ok"


gulp.task "coffee", ->
  gulp.src("*.coffee").pipe(coffee(
    bare: true
    sourceMap: true
  ).on("error", gutil.log)).pipe gulp.dest "./"

gulp.task "clean", ->
  gulp.src(paths.output,
    read: false
  ).pipe clean()

gulp.task "docco", ->
  gulp.src("*.coffee")
  .pipe(docco())
  .pipe gulp.dest("./docs")
