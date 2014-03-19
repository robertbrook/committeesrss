# This is a one-file prototype intended to:
# - hoover up HTML files of Evidence to Committees from data.parliament.uk, 
# - discard empty files and Written Evidence files,
# - convert HTML files to Markdown,
# - run through the Markdown files to identify and extract individual contributions,
# - save each contribution to a data store.

gulp = require "gulp"
clean = require "gulp-clean"
gutil = require "gulp-util"
docco = require "gulp-docco"
cheerio = require "gulp-cheerio"
filelog = require "gulp-filelog"
download = require "gulp-download"
rename = require "gulp-rename"
_ = require "underscore"
request = require "request"
fs = require "fs"
walk = require "walk"
cheerio = require "cheerio"
md = require 'html-md'
filesize = require 'filesize'
clc = require 'cli-color'
Parser = require("jison").Parser

# ### Notes
#https://www.npmjs.org/package/gulp-rss/
#Currently, gulp-cheerio uses cheerio ~0.13.0.
#newer     = require "gulp-newer"
#rss       = require "gulp-rss"
 
#leadingname: "^.*(?=:)"

paths =
  data: "data/*"
  output: "output/*"
  source: "http://data.parliament.uk/writtenevidence/WrittenEvidence.svc/EvidenceHtml/" 

gulp.task "log", ->
  gulp.src(paths.data)
  .pipe(filelog())
  .pipe(gulp.dest(paths.output))

gulp.task "download", ->
  for thisone in [1...7000]
    download paths.source + String("0000" + thisone).slice -4
    .pipe gulp.dest("data/")
    
gulp.task "markdown", ->
  walker = walk.walk("./data/")
  walker.on "file", (root, fileStats, next) ->
    fs.readFile root + fileStats.name, (err, data) ->
      
      if fileStats.size > 1647
        myString = md(data.toString())
        lines = myString.split "\n"
        intro = lines[0..2].toString()
        
        if (intro.toLowerCase().indexOf "oral evidence", 0) > -1        
          fs.writeFile "./output/#{fileStats.name}.md", myString, (err) ->
            if err
              console.log err
            else
              console.log clc.green "#{fileStats.name}: #{fileStats.name}.md, #{filesize fileStats.size, round: 0, unix: true} #{intro}\n"
        else
          console.log clc.yellow "#{fileStats.name}: NOT ORAL: #{intro}"
      else
        console.log clc.red "#{fileStats.name}: too small" 
      console.log "\n"
      next()

  walker.on "errors", (root, nodeStatsArray, next) ->
    console.log "error"
    next()

  walker.on "end", ->
    console.log "That's all folks."
    
    
gulp.task "parse", ->
  walker = walk.walk("./output/")
  walker.on "file", (root, fileStats, next) ->
    fs.readFile root + fileStats.name, (err, data) ->
      lines = data.toString().split "\n"
      lines.forEach (line) ->
        console.log line.match /^.*(?=:)/m
      next()

  walker.on "errors", (root, nodeStatsArray, next) ->
    console.log "error"
    next()

  walker.on "end", ->
    console.log "That's all folks."

gulp.task "default", ->
  console.log "Welcome to CommitteeRSS"

gulp.task "clobber", ->
  gulp.src paths.data
  .pipe(filelog('clean'))
  .pipe clean()
  
gulp.task "clean", ->
  gulp.src paths.output
  .pipe(filelog('clean'))
  .pipe clean()

gulp.task "docco", ->
  gulp.src("*.coffee")
  .pipe(docco())
  .pipe gulp.dest("./docs")
