(function() {
  (function(factory) {
    if (typeof exports === "object") {
      return module.exports = factory(require("node-localstorage"));
    } else if (typeof define === "function" && define.amd) {
      return define(["node-localstorage"], factory);
    }
  })(function(NodeLocalstorage) {
    var localStorage;
    if (typeof localStorage === "undefined" || localStorage === null) {
      localStorage = new NodeLocalstorage.LocalStorage("./localStorageDB");
    }
    return localStorage;
  });

}).call(this);
