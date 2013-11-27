# Cross environment wrapper for localStorage key/value persistence
#
( ( factory ) ->
    if typeof exports is "object"
        module.exports = factory(
            require "madlib-settings"
        )
    else if typeof define is "function" and define.amd
        define( [
            "madlib-settings"
        ], factory )

)( ( settings ) ->

    # Set default storage name in the settings
    #
    settings.init( "simpleStorageDatabase", "madSimpleStorage" )

    databaseName = settings.get( "simpleStorageDatabase" )
    storage      = undefined

    # Initialize storage based on availability
    #
    if localStorage?
        # Web browser localStorage is the interface we are emulating
        # Just return the original if we are in the browser
        #
        storage = localStorage

    else if Ti?
        itemCount = 0
        dbStorage = Ti.Database.open( databaseName )

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

                return result;

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
                    return dbStorage.getRowsAffected() > 0
                else
                    dbStorage.execute( "UPDATE items SET value='#{value}' WHERE key='#{key}'" )
                    return dbStorage.getRowsAffected() > 0

            removeItem: ( key ) ->
                return false if typeof key isnt "string"

                dbStorage.execute( "DELETE FROM items WHERE key='#{key}'" )
                return dbStorage.getRowsAffected() > 0

            clear: () ->
                dbStorage.execute( "DELETE FROM items" )
                return dbStorage.getRowsAffected() > 0

            key: ( index ) ->
                return false if typeof index isnt "number"

                resultSet = dbStorage.execute( "SELECT key FROM items LIMIT #{index}, 1" )
                if resultSet.next()
                    return resultSet.field( 0 )
                else
                    return undefined

    return storage
)