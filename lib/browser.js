(function() {
  (function(factory) {
    if (typeof exports === "object") {
      return module.exports = factory();
    } else if (typeof define === "function" && define.amd) {
      return define([], factory);
    }
  })(function() {
    var checkLocalStorageAvailable, dbStorage, itemCount, storage, updateItemCount;
    checkLocalStorageAvailable = function() {
      var checkAvailable, e;
      checkAvailable = "testing123";
      try {
        localStorage.setItem(checkAvailable, checkAvailable);
        localStorage.removeItem(checkAvailable);
        return true;
      } catch (_error) {
        e = _error;
        if (typeof console !== "undefined" && console !== null) {
          console.warn("[madlib-storage-simple] localStorage not available", e);
        }
        return false;
      }
    };
    if (checkLocalStorageAvailable()) {
      return localStorage;
    } else if (typeof Ti !== "undefined" && Ti !== null) {
      itemCount = 0;
      dbStorage = Ti.Database.open("madlibSimpleStorage");
      dbStorage.execute("CREATE TABLE IF NOT EXISTS items (key TEXT, value TEXT)");
      updateItemCount = function() {
        var resultSet;
        resultSet = dbStorage.execute("SELECT COUNT(*) FROM items");
        if (resultSet.next()) {
          return itemCount = resultSet.field(0);
        }
      };
      storage = {
        length: itemCount,
        getAll: function() {
          var result, resultSet;
          result = [];
          resultSet = dbStorage.execute("SELECT value, key FROM items");
          while (resultSet.isValidRow()) {
            result.push({
              key: resultSet.field(1),
              value: resultSet.field(0)
            });
            resultSet.next();
          }
          return result;
        },
        getItem: function(key) {
          var resultSet;
          if (typeof key !== "string") {
            return false;
          }
          resultSet = dbStorage.execute("SELECT value FROM items WHERE key='" + key + "'");
          if (resultSet.isValidRow()) {
            return resultSet.field(0);
          } else {
            return void 0;
          }
        },
        setItem: function(key, value) {
          if (typeof key !== "string" && typeof value !== "string") {
            return;
          }
          if (storage.getItem(key) === void 0) {
            dbStorage.execute("INSERT INTO items VALUES('" + key + "','" + value + "')");
            updateItemCount();
            return dbStorage.getRowsAffected() > 0;
          } else {
            dbStorage.execute("UPDATE items SET value='" + value + "' WHERE key='" + key + "'");
            updateItemCount();
            return dbStorage.getRowsAffected() > 0;
          }
        },
        removeItem: function(key) {
          if (typeof key !== "string") {
            return false;
          }
          dbStorage.execute("DELETE FROM items WHERE key='" + key + "'");
          updateItemCount();
          return dbStorage.getRowsAffected() > 0;
        },
        clear: function() {
          dbStorage.execute("DELETE FROM items");
          updateItemCount();
          return dbStorage.getRowsAffected() > 0;
        },
        key: function(index) {
          var resultSet;
          if (typeof index !== "number") {
            return false;
          }
          resultSet = dbStorage.execute("SELECT key FROM items LIMIT " + index + ", 1");
          if (resultSet.next()) {
            return resultSet.field(0);
          } else {
            return void 0;
          }
        }
      };
      return storage;
    } else {
      if (typeof console !== "undefined" && console !== null) {
        console.warn("[madlib-storage-simple] Using an in-memory storage alternative");
      }
      itemCount = 0;
      dbStorage = [];
      storage = {
        length: itemCount,
        getAll: function() {
          var key, result, value;
          result = [];
          for (key in dbStorage) {
            value = dbStorage[key];
            result.push({
              key: key,
              value: value
            });
          }
          return result;
        },
        getItem: function(key) {
          return dbStorage[key];
        },
        setItem: function(key, value) {
          if (typeof key !== "string" && typeof value !== "string") {
            return;
          }
          dbStorage[key] = value;
          itemCount++;
          return true;
        },
        removeItem: function(key) {
          if (typeof key !== "string") {
            return false;
          }
          if (dbStorage[key]) {
            delete dbStorage[key];
            itemCount--;
          }
          return true;
        },
        clear: function() {
          dbStorage = {};
          itemCount = 0;
          return true;
        },
        key: function(index) {
          var i, key, value;
          if (typeof index !== "number") {
            return false;
          }
          i = 0;
          for (key in dbStorage) {
            value = dbStorage[key];
            if (index === i) {
              return key;
            }
            i++;
          }
        }
      };
      return storage;
    }
  });

}).call(this);
