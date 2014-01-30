# Cross environment wrapper for localStorage key/value persistence
#
( ( factory ) ->
    if typeof exports is "object"
        module.exports = factory(
            require "node-localstorage"
        )
    else if typeof define is "function" and define.amd
        define( [
            "node-localstorage"
        ], factory )

)( ( NodeLocalstorage ) ->

    # If native localStorage exists use that instead
    #
    if not localStorage?
        localStorage = new NodeLocalstorage.LocalStorage( "./localStorageDB" )

    return localStorage
)