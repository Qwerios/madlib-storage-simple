chai            = require "chai"
localStorage    = require "../lib/index.js"

describe( "localStorage", () ->
    describe( "#setItem()", () ->
        it( "Should set storage item", () ->
            localStorage.setItem( "unit-test", "done" )

            chai.expect( localStorage.getItem( "unit-test" ) ).to.eql( "done" )

            localStorage._deleteLocation()  # cleans up ./storage created during unit test
        )
    )
)