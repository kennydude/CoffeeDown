# Iterator
# TODO: Move to external module

class Iterator
    constructor: (@array) ->
        @i = -1

    next : () ->
        r = @peek()
        if r != null
            @i += 1
        return r

    peek : () ->
        r = @array[ @i + 1 ]
        if !r
            r = null
        return r

    hasNext : () ->
        return @i < @array.length

module.exports = Iterator
