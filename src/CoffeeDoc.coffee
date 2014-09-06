CoffeeScript = require "coffee-script"
CoffeeScript.Nodes = require "coffee-script/lib/coffee-script/nodes.js"
fs = require "fs"
flatten = CoffeeScript.helpers.flatten

verbs = require "methods"
verbs.push "all"

if typeof String.prototype.startsWith != 'function'
  # http://stackoverflow.com/a/646643/230419
  String.prototype.startsWith = (str) ->
    return this.slice(0, str.length) == str

class @ExpressDoc
    constructor: (file) ->
        @endpoints = []
        nodes = CoffeeScript.nodes( fs.readFileSync(__dirname+"/test.coffee").toString(), {})

        # This is done this way due to needing to backtrack!
        for attr in nodes.children when nodes[attr]
            allNodes = flatten [nodes[attr]]
            for k, node of allNodes

                if node instanceof CoffeeScript.Nodes.Call
                    # Check if it was an app.x method
                    if verbs.indexOf(node.variable.properties[0].name.value) != -1 && node.variable.base.value == "app"

                        if k-1 > 0
                            prevNode = allNodes[k-1]
                            if prevNode instanceof CoffeeScript.Nodes.Comment
                                method = node.variable.properties[0].name.value
                                comment = prevNode.comment.trim()
                                path = JSON.parse(node.args[0].base.value)

                                @addNode method, path, comment

    data : () ->
        return {
            "endpoints" : @endpoints
        }

    parseParam : (line) ->
        parts = line.split " "
        if (parts[2].charAt(0) == "{" && parts[2].charAt(parts[2].length-1) == "}")
            type = parts[2].substring(1, parts[2].length-1).toLowerCase()

        name = parts[1]
        parts.splice 0, 2 + (1 if type)

        return {
            name : name,
            type : type,
            description : parts.join " "
        }

    parseNamedParamters : (parts) ->
        if typeof parts == "string"
            parts = parts.split " "

        params = {}
        for part in parts
            ix = part.indexOf(":")
            if ix > 0
                k = part.substr(0, ix)
                v = part.substr(ix+1)

                if params[k]
                    if typeof params[k] == "string"
                        params[k] = [ params[k] ]
                    params[k].push v
                else
                    params[ k ] = v

        return params

    doAuth : (type, parts) ->
        parts = parts.slice 2
        np = @parseNamedParamters parts
        np.type = type
        @_auth = np

    processLine : (line) ->
        command = line.split(" ")[0]
        switch command
            when "@query"
                @_qs.push @parseParam line
            when "@body"
                @_body.push @parseParam line
            when "@param"
                @_params.push @parseParam line
            when "@auth"
                # This depends on certain things to do with auth
                parts = line.split " "
                switch parts[1] # Auth Type
                    when "oauth1.0", "oauth1.0a", "oauth1"
                        @doAuth "oauth1", parts
                    when "oauth2", "oauth2.0"
                        @doAuth "oauth2", parts
                    else
                        console.warn "Unknown auth type: #{parts[1]}"
            else
                console.warn "Unknown @block: #{command}"

    addNode: (method, path, comment) ->
        description = []
        lines = comment.split("\n")
        for k, line of lines
            if line.trim().charAt(0) == "@"
                lines.splice(0, k)
                break
            else
                description.push line
        description = description.join("\n")

        @_qs = []
        @_body = []
        @_params = []
        @_auth = null

        pl = []
        for line in lines
            line = line.trim()
            if line.charAt(0) == "@"
                if pl.length > 0
                    @processLine(pl.join "\n")
                pl = []

            pl.push line

        if pl.length > 0
            @processLine(pl.join "\n")

        @endpoints.push {
            method : method.toUpperCase(),
            path : path,
            short_description : description.split("\n")[0]
            description : description,
            params : @_params,
            query_string : @_qs,
            body : @_body,
            auth : @_auth
        }
