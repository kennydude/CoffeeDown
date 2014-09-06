CoffeeDoc = require "./CoffeeDoc"
Iterator = require "./Iterator" # TODO: Move to ext module
ansi = require "ansi"
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
    options = {}
    args = new Iterator ( args.slice(1) )

    while (arg = args.next()) != null
        switch arg
            when "-m", "--markdown", "-markdown"
                options.markdown = args.next()
            when "-j", "--json", "-json"
                option.json = args.next()
            else
                files.push arg

switch command
    when "express"
        for file in files
            console.info "Processing #{file}..."
            cd = new CoffeeDoc.ExpressDoc(file)
            console.log JSON.stringify cd.endpoints, null, 4
    else
        # Help
        console.log """
coffeedoc
---
CoffeeScript + Documentation + Markdown = <3

Usage:

* coffeedoc express [coffeescript files]
  This command produces API documentation based on express methods
  and comments
* coffeedoc classdoc [coffeescript files]
  This command produces API documentation based on classes and
  comments

Options:

* -markdown <filename>
  Output a markdown file based on the data collected
* -json <filename>
  Output a JSON file based on the data collected
"""
