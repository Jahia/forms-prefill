<%@ page contentType="text/javascript" %>

(function () {
    'use strict';

    var chuckNorrisPrefillService = function (contextualData, $q, $http) {

        var dataCache = null;
        var q = null;

        /**
         * MUST IMPLEMENT
         *
         * Gets data for prefill which must be an object:  { key: value, ... }
         * @returns {Promise}
         */
        this.getData = function() {
            if (dataCache !== null) {
                return $q(function(resolve, reject) {
                    resolve(dataCache);
                });
            }

            if (q !== null) {
                return q;
            }

            q = $q(function(resolve, reject) {
                $http({
                    url: "http://api.icndb.com/jokes/random?firstName=Chuck&lastName=Norris",
                    method: 'GET'
                }).then(function(data) {
                    console.log("Chuck Norris prefill", data);
                    //Manipulate data as you see fit
                    var d = data.value;
                    if (d.categories.length > 0) {
                        d.category = d.categories.join(",");
                        delete d.categories;
                    }
                    //Cache data to avoid future requests
                    dataCache = d;
                    resolve(dataCache);
                }, function(error) {
                    reject(error);
                });
            });
            return q;
        }
    };

    angular.module('formFactory')
            .service('chuckNorrisPrefillService', ["contextualData",
                "$q", "$http", chuckNorrisPrefillService]);
})();