( ( factory ) ->
    if typeof exports is "object"
        module.exports = factory(
        )
    else if typeof define is "function" and define.amd
        define( [
        ], factory )

)( () ->
    # Start your module code here
)