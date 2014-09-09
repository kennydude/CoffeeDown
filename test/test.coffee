express = require "express"
app = express()

app.set "pie", "moo"

###
Get my api
@query testFilter {String} TEST filter
    ok i am a test!
@auth oauth2 scope:test scope:help
###
app.get "/myapi", (req, res) ->
    res.end "todo"

###
POST MY API
@body pie1 {String} Pie ID
###
app.post "/pie", (req, res) ->
    res.end "todo"

###
POST MY API
@body pie1 {String} Pie ID
@body pie2 {String} Pie ID
    i dk
###
app.post "/egg", (req, res) ->
    res.end "todo"

module.exports = (app) ->

    ###
    Test Indented API
    @body pie1 {String} Pie ID
    @body pie2 {String} Pie ID
        i dk
    ###
    app.post "/poop", (req, res) ->
        res.end "todo"
