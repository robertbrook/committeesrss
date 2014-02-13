gulp      = require "gulp"
clean     = require "gulp-clean"
gutil     = require "gulp-util"
docco     = require "gulp-docco"
html2md   = require "gulp-html2md"
cheerio   = require "gulp-cheerio"
filelog   = require "gulp-filelog"
newer     = require "gulp-newer"
rss       = require "gulp-rss"
download  = require "gulp-download"
_         = require "underscore"
request   = require "request"
fs        = require "fs"
walk      = require "walk"
cheerio   = require "cheerio"

#https://www.npmjs.org/package/gulp-rss/
#Currently, gulp-cheerio uses cheerio ~0.13.0.

loggit = (text) ->
  console.log (text)

paths =
  data: "data/*"
  output:"output/*"
  
gulp.task "logg", ->  
  gulp.src(paths.data)
    .pipe(filelog())
    .pipe(gulp.dest(paths.output))
    
gulp.task "download", ->  
  download(target_array)
    .pipe(gulp.dest("data/"));
    
gulp.task "default", ->
#  loggit _.range(0, 7000, 50)
  loggit gutil.env.type
  
gulp.task "server", ->
  console.log "ok"
  walker = walk.walk("./data/")

  walker.on "file", (root, fileStats, next) ->
    fs.readFile root + fileStats.name, (err, data) ->
      $ = cheerio.load(data)
      myString = ""
      $("p span").each (index, element) ->
        if element.attribs["style"]
          if ~(element.attribs["style"]).indexOf("bold")
            # ## Header
            # I found something _bold!_
            myString += "\n\n[[[" + element.children[0].data + "]]]"
          
          else
            # this is just normal text
            # This is an [example link](http://example.com/).
            myString += element.children[0].data
  #          myString += "\n"
        
      if fileStats.size > 1647        
        fs.writeFile "./output/" + fileStats.name + ".txt", myString, (err) ->
          if err
            console.log err
          else
            console.log "Wrote out " + fileStats.name + ".txt, " + fileStats.size
      next()

  walker.on "errors", (root, nodeStatsArray, next) ->
    console.log "error"
    next()

  walker.on "end", ->
    console.log "That's all folks."

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
  )
  .pipe(filelog('clean'))
  .pipe clean()

gulp.task "docco", ->
  gulp.src("*.coffee")
  .pipe(docco())
  .pipe gulp.dest("./docs")
