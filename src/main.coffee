CoffeeDoc = require "./CoffeeDoc"
Iterator = require "./Iterator" # TODO: Move to ext module
ansi = require "ansi"
fs = require "fs"
path = require "path"
cursor_error = ansi(process.stderr)
cursor = ansi(process.stdout)

args = process.argv.slice 2
command = args[0]

# Override things to make them pretty

console.error = (msg) ->
    cursor_error.red().bold().write("[ERR]  ")
    cursor_error.reset().write(msg + "\n")

console.warn = (msg) ->
    cursor_error.hex('#FF6600').write("[WARN] ")
    cursor_error.reset().write(msg + "\n")

console.info = (msg) ->
    cursor.green().write("[INFO] ")
    cursor.reset().write(msg + "\n")

if command

    files = []
    options = {
        markdown_template : path.join __dirname, "template.md"
    }

    args = new Iterator ( args.slice(1) )

    while (arg = args.next()) != null
        switch arg
            when "-m", "--markdown", "-markdown"
                options.markdown = args.next()
            when "-j", "--json", "-json"
                option.json = args.next()
            when "-mt", "--markdownTemplate", "-markdownTemplate"
                options.markdown_template = args.next()
            else
                files.push arg

data = {}
addData = (d) ->
    for key, value of d
        if Array.isArray value
            if !data[key]
                data[key] = []
            for item in value
                data[key].push item
        else
            console.warn "Unknown Error: #{k} is invalid"

doData = () ->
    console.info "Finishing processing"
    if options.markdown
        console.info "Outputting Markdown to #{options.markdown}"
        swig = require "swig"

        # This is to do bullet lists
        swig.setFilter "indentNL", (input) ->
            lines = input.split("\n")
            return lines[0] + "\n  #{line}" for line in lines.slice(1)

        markdown = swig.renderFile( options.markdown_template, data )

        # Remove 3 or more blank lines in a row
        markdown = markdown.replace( /(\n\n\n\n+)/g, "\n\n" )

        console.log markdown

switch command
    when "express"
        for file in files
            console.info "Processing #{file}"
            cd = new CoffeeDoc.ExpressDoc(file)
            d = cd.data()
            addData d

        doData()
        console.log JSON.stringify( data, null, 4 )
    else
        # Help
        console.log fs.readFileSync( path.join __dirname, "..", "USAGE.md" ).toString()
