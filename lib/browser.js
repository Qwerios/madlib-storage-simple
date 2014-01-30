(function() {

  (function(factory) {
    if (typeof exports === "object") {
      return module.exports = factory();
    } else if (typeof define === "function" && define.amd) {
      return define([], factory);
    }
  })(function() {
    var dbStorage, itemCount, storage, updateItemCount;
    if (typeof localStorage !== "undefined" && localStorage !== null) {
      return localStorage;
    }
    if (typeof Ti !== "undefined" && Ti !== null) {
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
            return dbStorage.getRowsAffected() > 0;
          } else {
            dbStorage.execute("UPDATE items SET value='" + value + "' WHERE key='" + key + "'");
            return dbStorage.getRowsAffected() > 0;
          }
        },
        removeItem: function(key) {
          if (typeof key !== "string") {
            return false;
          }
          dbStorage.execute("DELETE FROM items WHERE key='" + key + "'");
          return dbStorage.getRowsAffected() > 0;
        },
        clear: function() {
          dbStorage.execute("DELETE FROM items");
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
    }
  });

}).call(this);
