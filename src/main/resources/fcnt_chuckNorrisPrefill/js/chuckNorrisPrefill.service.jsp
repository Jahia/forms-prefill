<%@ page contentType="text/javascript" %>

(function () {
    'use strict';

    var chuckNorrisPrefillService = function (contextualData, $timeout, $http, $q) {

        var dataCache = null;
        var deferred = null;

        /**
         * MUST IMPLEMENT
         *
         * Gets data for prefill which must be an object:  { key: value, ... }
         * @returns {Promise}
         */
        this.getData = function() {
            if (deferred !== null) {
                return deferred;
            }

            deferred = $q.defer();

            if (dataCache !== null) {
                $timeout(function(resolve, reject) {
                    deferred.resolve(dataCache);
                }, 100);
                return deferred;
            }

            $http({
                url: "http://api.icndb.com/jokes/random?firstName=Chuck&lastName=Norris",
                method: 'GET'
            }).then(function(data) {
                console.log("Chuck Norris prefill", data);
                //Manipulate data as you see fit
                var d = data.data.value;
                if (d.categories.length > 0) {
                    d.category = d.categories.join(",");
                    delete d.categories;
                }
                //Cache data to avoid future requests
                dataCache = d;
                deferred.resolve(dataCache);
            }, function(error) {
                deferred.reject(error);
            });

            //Note that we return deferred object and not its promise
            return deferred;
        };
    };

    angular.module('formFactory')
            .service('chuckNorrisPrefillService', ["contextualData",
                "$timeout", "$http", "$q", chuckNorrisPrefillService]);
})();