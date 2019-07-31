<%@ page contentType="text/javascript" %>

(function () {
    'use strict';

    var userInfoPrefillService = function (contextualData, $q, $http, $timeout) {

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
                //Entry point implemented in forms-core module as an example
                url: contextualData.context + contextualData.apiEntryPoint + '/userinfo/' + contextualData.locale,
                method: 'GET'
            }).then(function(data) {
                console.log("User info prefill service", data);
                //Manipulate data as you see fit

                //Cache data to avoid future requests
                dataCache = data.data;
                deferred.resolve(dataCache);
            }, function(error) {
                deferred.reject(error);
            });
            return deferred;
        }
    };

    angular.module('formFactory')
            .service('userInfoPrefillService', ["contextualData",
                "$q", "$http", "$timeout", userInfoPrefillService]);
})();