# This is a one-file prototype intended to:
# - hoover up HTML files of Evidence to Committees from data.parliament.uk,
# - discard empty files and Written Evidence files,
# - convert HTML files to Markdown,
# - identify and extract individual contributions in Markdown files,
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
md = require 'html-md'
filesize = require 'filesize'
clc = require 'cli-color'
S = require "string"
pg = require("pg")

conString = "postgres://localhost/oralevidence_development"

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
    name = fileStats.name
    size = fileStats.size
    fs.readFile root + name, (err, data) ->
      
      if size > 1647
        myString = md(data.toString())
        lines = S(myString).lines()
        intro = lines[0..2].toString()
        
        if (intro.toLowerCase().indexOf "oral evidence", 0) > -1
          fs.writeFile "./output/#{name}.md", myString, (err) ->
            if err
              console.log err
            else
              console.log clc.green "#{name}: #{name}.md\n#{intro}\n"
        else
          console.log clc.yellow "#{name}: not Oral Evidence\n"
      else
        console.log clc.red "#{name}: too small\n"
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
      bits = data.toString().split /(Q\d*)\s(.*)(?=:)/
      bits.shift()
      
      while bits.length
        question = []
        question = bits.splice(0, 3)
      
        pg.connect conString, (err, client, done) ->
          return console.error("error fetching client from pool", err)  if err
          client.query 'INSERT into questions (qnumber, qname, qtext) VALUES($1, $2, $3) returning id', question, (err, result) ->
            done()
            return console.error("error running query", err)  if err
            console.log result.rows
            return
          return
      
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
