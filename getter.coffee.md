Getter is a utility to fetch evidence to Parliamentary committees from data.parliament.uk and make their content available for onward use.

    request = require("request")
    fs = require("fs")
    walk = require("walk")

Cheerio is a helper from Matthew Mueller: http://matthewmueller.github.io/cheerio/

    cheerio = require("cheerio")
    
    walker = walk.walk("./data/")
    
    walker.on "file", (root, fileStats, next) ->
      fs.readFile root + fileStats.name, (err, data) ->
            
        $ = cheerio.load(data)
        myString = ""
        myState = "default"
        $("p span").each (index, element) ->
          if element.attribs["style"]
            if ~(element.attribs["style"]).indexOf("bold")
              myString += element.children[0].data
              myState = "[bold]"
            else
              myState = "[normal]"
              myString += element.children[0].data
              myString += "\n"
            myString += myState
        if fileStats.size > 1647        
          fs.writeFile "./output/" + fileStats.name, myString, (err) ->
            if err
              console.log err
            else
              console.log "Wrote out " + fileStats.name + ", " + fileStats.size
        next()

    walker.on "errors", (root, nodeStatsArray, next) ->
      console.log "error"
      next()

    walker.on "end", ->
      console.log "That's all folks."
    

              
That's all folks.