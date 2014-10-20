# Cross environment wrapper for localStorage key/value persistence
#
( ( factory ) ->
    if typeof exports is "object"
        module.exports = factory(
        )
    else if typeof define is "function" and define.amd
        define( [
        ], factory )
)( () ->

    checkLocalStorageAvailable = () ->
        checkAvailable = "testing123"
        try
            localStorage.setItem( checkAvailable, checkAvailable )
            localStorage.removeItem( checkAvailable )
            return true
        catch e
            console?.warn( "[madlib-storage-simple] localStorage not available", e )
            return false

    # Web browser localStorage is the interface we are emulating
    # Just return the original if we are in the browser
    #
    if checkLocalStorageAvailable()
        return localStorage

    else if Ti?
        # For Titanium will will emulate localStorage using a simpleDB solution
        #
        itemCount = 0
        dbStorage = Ti.Database.open( "madlibSimpleStorage" )

        # Initialise the database if needed
        #
        dbStorage.execute( "CREATE TABLE IF NOT EXISTS items (key TEXT, value TEXT)" )

        updateItemCount = () ->
            resultSet = dbStorage.execute( "SELECT COUNT(*) FROM items" )
            if resultSet.next()
                itemCount = resultSet.field( 0 )

        storage =
            length: itemCount

            getAll: ()->
                result = []
                resultSet = dbStorage.execute( "SELECT value, key FROM items" )

                while resultSet.isValidRow()
                    result.push(
                        key:    resultSet.field( 1 )
                        value:  resultSet.field( 0 )
                    )
                    resultSet.next()

                return result

            getItem: ( key ) ->
                return false if typeof key isnt "string"

                resultSet = dbStorage.execute( "SELECT value FROM items WHERE key='#{key}'" )
                if resultSet.isValidRow()
                    return resultSet.field( 0 )
                else
                    return undefined

            setItem: ( key, value ) ->
                return if typeof key isnt "string" and typeof value isnt "string"

                # First check if the item exists
                #
                if storage.getItem( key ) is undefined
                    dbStorage.execute( "INSERT INTO items VALUES('#{key}','#{value}')" )
                    updateItemCount()
                    return dbStorage.getRowsAffected() > 0
                else
                    dbStorage.execute( "UPDATE items SET value='#{value}' WHERE key='#{key}'" )
                    updateItemCount()
                    return dbStorage.getRowsAffected() > 0

            removeItem: ( key ) ->
                return false if typeof key isnt "string"

                dbStorage.execute( "DELETE FROM items WHERE key='#{key}'" )
                updateItemCount()
                return dbStorage.getRowsAffected() > 0

            clear: () ->
                dbStorage.execute( "DELETE FROM items" )
                updateItemCount()
                return dbStorage.getRowsAffected() > 0

            key: ( index ) ->
                return false if typeof index isnt "number"

                resultSet = dbStorage.execute( "SELECT key FROM items LIMIT #{index}, 1" )
                if resultSet.next()
                    return resultSet.field( 0 )
                else
                    return undefined

        return storage

    else
        # Return an in-memory alternative
        #
        console?.warn( "[madlib-storage-simple] Using an in-memory storage alternative" )
        itemCount = 0
        dbStorage = []

        storage =
            length: itemCount

            getAll: ()->
                result = []

                for key, value of dbStorage
                    result.push(
                        key:    key
                        value:  value
                    )

                return result

            getItem: ( key ) ->
                return dbStorage[ key ]

            setItem: ( key, value ) ->
                return if typeof key isnt "string" and typeof value isnt "string"

                dbStorage[ key ] = value
                itemCount++
                return true

            removeItem: ( key ) ->
                return false if typeof key isnt "string"

                if dbStorage[ key ]
                    delete dbStorage[ key ]
                    itemCount--

                return true

            clear: () ->
                dbStorage = {}
                itemCount = 0
                return true

            key: ( index ) ->
                return false if typeof index isnt "number"

                i = 0
                for key, value of dbStorage
                    if index is i
                        return key
                    i++

                return

        return storage
)
