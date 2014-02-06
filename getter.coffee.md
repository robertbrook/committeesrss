Getter is a utility to fetch evidence to Parliamentary committees from data.parliament.uk and make their content available for onward use.

    request = require("request")

Cheerio is a helper from Matthew Mueller: http://matthewmueller.github.io/cheerio/

    cheerio = require("cheerio")

    request "http://data.parliament.uk/writtenevidence/WrittenEvidence.svc/EvidenceHtml/5533", (error, response, body) ->
      if not error and response.statusCode is 200
        $ = cheerio.load(body)
        myString = ""
        myState = "default"
        $("p span").each (index, element) ->
          if ~(element.attribs["style"]).indexOf("bold")
            myString += element.children[0].data
            myState = "[bold]"
          else
            myState = "[normal]"
            myString += element.children[0].data
            myString += "\n"
          myString += myState
          return

        console.log myString
      return

Finished now